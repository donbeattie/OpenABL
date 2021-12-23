class abl.kafka.type.Header:
  define public property Name  as character no-undo get. set.
  define public property Value as character no-undo get. set.
  
  constructor public Header ():
    super ().
    
    return.
  end.

  constructor public Header
    (ip_cName  as character,
     ip_cValue as character):
     
    super().
    
    assign this-object:Name  = ip_cName
           this-object:Value = ip_cValue
           .

    return.
  end.
  
end class.