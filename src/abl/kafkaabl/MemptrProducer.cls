block-level on error undo, throw.

class abl.kafka.MemptrProducer
  inherits abl.kafka.aProducer:
 
  constructor public MemptrProducer
    (ip_cBootstrapServer as character):
     
    super ("MemptrSerializer":u, ip_cBootstrapServer).
    
    return.            
  end constructor.  
 
  method public void Send
    (ip_cDestinationTopic as character,
     ip_mMessage          as memptr):
    var abl.kafka.type.Header[] oHeader.
    
    this-object:Send(ip_cDestinationTopic, ip_mMessage, oHeader).
  
    return.
  end method.
      
  method public void Send
    (ip_cDestinationTopic as character,
     ip_mMessage          as memptr,
     ip_oHeader           as abl.kafka.type.Header extent):

    oRecordBuilder:SetBody(ip_mMessage).
    
    super:Send(ip_cDestinationTopic, ip_oHeader).

    return.
  end method. 
end class.