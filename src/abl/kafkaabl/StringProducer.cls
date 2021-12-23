block-level on error undo, throw.

class abl.kafka.StringProducer
  inherits abl.kafka.aProducer:
 
  constructor public StringProducer
    (ip_cBootstrapServer as character):
     
    super ("StringSerializer":u, ip_cBootstrapServer).
    
    return.            
  end constructor.  
 
  method public void Send
    (ip_cDestinationTopic as character,
     ip_oMessage          as abl.kafka.type.Message):
    var abl.kafka.type.Header[] oHeader.
    
    this-object:Send(ip_cDestinationTopic, ip_oMessage, oHeader).
  
    return.
  end method.
      
  method public void Send
    (ip_cDestinationTopic as character,
     ip_oMessage          as abl.kafka.type.Message,
     ip_oHeader           as abl.kafka.type.Header extent):

    oRecordBuilder:SetBody(ip_oMessage:Body).
    
    super:Send(ip_cDestinationTopic, ip_oHeader).

    return.
  end method. 
end class.