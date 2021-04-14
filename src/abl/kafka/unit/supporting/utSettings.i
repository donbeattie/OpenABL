/* file: utSettings.i                                                         */
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
&global-define KafkaClientVersion       17170943
&global-define KafkaClientVersionString 1.6.1

&global-define UnitTestTopic            unittestevent

// Message Consumer/Consumer
&global-define MessageConsumerLog       session:temp-directory + "UnitTestMessageConsumer.log":u


/*----------------------------------------------------------------------------*/
/* end-of-file: utSettings.i                                                  */