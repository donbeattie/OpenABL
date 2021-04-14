/* file: Configuration.cls                                                    */
/*----------------------------------------------------------------------------*/
/*
 * Copyright 2021 Don Beattie
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. 
*/
/*----------------------------------------------------------------------------*/
/*
   Implementation used for Unit Testing and as an example.
*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw. 

using abl.kafka.type.ConfigurationCategory. 

class abl.kafka.unit.supporting.Configuration
  implements abl.kafka.IConfiguration:
 
  define private temp-table ttProperty no-undo serialize-name "Property":u
    field Category as int64
    field KeyName  as character
    field KeyValue as character
    index idxKeyName  is primary unique KeyName
    index idxCategory Category
    .
    
  constructor public Configuration ():
    super ().
    
    Initialize ().
    
    return.
  end constructor. 
  
  destructor public Configuration ():

    empty temp-table ttProperty no-error.   
     
    return.
  end destructor. 
  
  method private void Initialize ():
    
    // Global configuration properties
    // General Properties
    this-object:Add(ConfigurationCategory:GENERAL, "client.id":u,         abl.system.Computer:Hostname()).
    this-object:Add(ConfigurationCategory:GENERAL, "bootstrap.servers":u, "192.168.50.55:9092":u).

    // Consumer Properties
    this-object:Add(ConfigurationCategory:CONSUMER, "group.id":u,          "SomeGroupID":u).
    this-object:Add(ConfigurationCategory:CONSUMER, "auto.offset.reset":u, "earliest":u).
    
    
    //Topic configuration properties
    this-object:Add(ConfigurationCategory:TOPIC, "acks":u, "all":u).
    
    return.
  end method.
  
  // Shortcut assuming all property names are unique. Not enforcing this...
  method public character Get
    (ip_cKeyName as character):
    
    for first ttProperty no-lock
        where ttProperty.KeyName  = ip_cKeyName:
        return ttProperty.KeyValue.
    end.
    
    return ?.
  end method.

  method public OpenEdge.Core.KeyValuePair extent Get 
    (ip_eCategory as ConfigurationCategory):
    define variable oProperty as OpenEdge.Core.KeyValuePair extent no-undo.
    
    for each ttProperty no-lock
        where ttProperty.Category = ip_eCategory:GetValue():
         assign extent(oProperty) = (if extent(oProperty) = ? then 1 else extent(oProperty) + 1)
                oProperty[extent(oProperty)] = new OpenEdge.Core.KeyValuePair(ttProperty.KeyName, 
                                                                              ttProperty.KeyValue)
                .
    end.
    
    return oProperty.
  end method.
  
  method private void Add
    (ip_eCategory as ConfigurationCategory,
     ip_cKeyName  as character,
     ip_cKeyValue as character):
      
    if not can-find(first ttProperty
                    where ttProperty.Category = ip_eCategory:GetValue()
                      and ttProperty.KeyName  = ip_cKeyName) then do:
       create ttProperty.
       assign ttProperty.Category = ip_eCategory:GetValue()
              ttProperty.KeyName  = ip_cKeyName
              ttProperty.KeyValue = ip_cKeyValue
              .
    end.
    else
      undo, throw new Progress.Lang.AppError(substitute("&1 property &2 already exists. Cannot Add.":u, 
                                                        ip_eCategory:ToString(),
                                                        ip_cKeyName)).
          
    return.
  end method. 
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Configuration.cls                                             */