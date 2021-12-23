block-level on error undo, throw.

class abl.kafka.JsonProducer
  inherits abl.kafka.aProducer:
     
  constructor public JsonProducer
    (ip_cBootstrapServer as character):
     
    super ("JsonSerializer":u, ip_cBootstrapServer).
    
    return.            
  end constructor.  
 
  method public void Send
    (ip_cDestinationTopic as character,
     ip_oJsonObject       as Progress.Json.ObjectModel.JsonConstruct):
    var abl.kafka.type.Header[] oHeader.
    
    this-object:Send(ip_cDestinationTopic, ip_oJsonObject, oHeader).
  
    return.
  end method.
      
  method public void Send
    (ip_cDestinationTopic as character,
     ip_oJsonObject       as Progress.Json.ObjectModel.JsonConstruct,
     ip_oHeader           as abl.kafka.type.Header extent):

    oRecordBuilder:SetBody(ip_oJsonObject).
    
    super:Send(ip_cDestinationTopic, ip_oHeader).

    return.
  end method.
end class.