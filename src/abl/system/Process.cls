block-level on error undo, throw.

class abl.system.Process:
  
  method static public void Nap
    (ip_iMilliseconds as integer):
&if "{&opsys}":u begins "WIN":u &then
    System.Threading.Thread:Sleep(ip_iMilliseconds).
&else
    pause (ip_iMilliseconds / 1000) no-message.
&endif
    return.
  end method.    

&if "{&opsys}":u begins "WIN":u &then
&else
  method static public character UnixName ():
    var character cUnixName.
    
    input through value("uname":u).
    import unformatted cUnixName.
    input close.
    
    return trim(cUnixName).
  end method.
&endif

  
end class.