class abl.kafka.type.Message:
  define public property Body   as longchar no-undo get. set. 
  define public property Header as abl.kafka.type.Header extent get. set.
end class.