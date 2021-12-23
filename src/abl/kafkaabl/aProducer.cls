block-level on error undo, throw.

class abl.kafka.aProducer abstract:
 
  var protected OpenEdge.Messaging.IProducer oProducer.
  var protected OpenEdge.Messaging.RecordBuilder oRecordBuilder.
  var private character cSerializer.
  
  constructor public aProducer
    (ip_cSerializer      as character,
     ip_cBootstrapServer as character):
     
    super ().
        
    if    ip_cSerializer = "JsonSerializer":u
       or ip_cSerializer = "StringSerializer":u
       or ip_cSerializer = "MemptrSerializer":u then     
       assign cSerializer = substitute("OpenEdge.Messaging.&1":u, ip_cSerializer).
    else
       undo, throw new Progress.Lang.AppError(substitute("Invalid Serializer supplied (&1).", ip_cSerializer), 0).
    
    SetupProducer(ip_cBootstrapServer).
       
    return.   
  end constructor. 
  
  
  method public void Send
    (ip_cDestinationTopic as character,
     ip_oHeader           as abl.kafka.type.Header extent):
         
    var OpenEdge.Messaging.IProducerRecord oRecord.
    var OpenEdge.Messaging.ISendResponse oResponse.
    var integer iLoop.

    oRecordBuilder:SetTopicName(ip_cDestinationTopic).
    
    AddHeaders(oRecordBuilder, ip_oHeader).
    
    oRecord = oRecordBuilder:Build().

    oResponse = oProducer:Send(oRecord).
    oProducer:Flush(5000).   
    
    repeat while not oResponse:Completed:
      abl.system.Process:Nap(50).
    end.

    if not oResponse:Success then
       undo, throw new Progress.Lang.AppError(substitute("Failed to send the record: &1", 
                                                         oResponse:ErrorMessage), 0).
         
    return.
    finally:
      delete object oRecord no-error. 
    end finally.
  end method.  
  
  
  
 
  method protected void AddHeaders
    (ip_oRecordBuilder as OpenEdge.Messaging.RecordBuilder,
     ip_oHeader        as abl.kafka.type.Header extent):      
    var integer iLoop.
    
    ip_oRecordBuilder:AddHeader("my_correlation_id":u, guid).
    
    do iLoop = 1 to extent(ip_oHeader):
       if valid-object(ip_oHeader[iLoop])
          and ip_oHeader[iLoop]:Name <> ?
          and ip_oHeader[iLoop]:Name <> "":u then
          ip_oRecordBuilder:AddHeader(ip_oHeader[iLoop]:Name,
                                      ip_oHeader[iLoop]:Value). 
    end. 
    
    return.
  end method.
  
  method private void SetupProducer
    (ip_cBootstrapServer as character):
    var OpenEdge.Messaging.ProducerBuilder oProducerBuilder.
    
    oProducerBuilder = OpenEdge.Messaging.ProducerBuilder:Create("progress-kafka":u).
    oProducerBuilder:SetProducerOption("bootstrap.servers":u, ip_cBootstrapServer).
    oProducerBuilder:SetProducerOption("value.serializer":u, cSerializer).
    oProducer = oProducerBuilder:Build().
    oRecordBuilder = oProducer:RecordBuilder.
  
    return.
    finally:
      delete object oProducerBuilder no-error.    
    end finally.
  end method.
 
end class.