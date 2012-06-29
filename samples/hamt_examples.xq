xquery version "3.0";

(:
 : Copyright (c) 2010-2012 John Snelson
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :     http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)

import module namespace hamt = "http://snelson.org.uk/functions/hamt" at "../hamt.xq";

let $hf := function($a) {
  xs:integer(fn:fold-left(
    function($z,$v) { ($z * 5 + $v) mod 4294967296 },
    2489012344,
    fn:string-to-codepoints(fn:string($a))
  ))
}
let $eq := function($a,$b) { $a eq $b }
let $hamt := hamt:create()
let $hamt1 := hamt:put($hf,$eq,$hamt,"fredrick")
let $hamt2 := hamt:put($hf,$eq,$hamt1,"noggin")
let $hamt3 := hamt:put($hf,$eq,$hamt2,"murphy")
let $hamt4 := hamt:put($hf,$eq,$hamt3,"chicken")
let $hamtdel := hamt:delete($hf,$eq,$hamt4,"fredrick")
let $hamtdel := hamt:delete($hf,$eq,$hamtdel,"chicken")
let $hamtdel := hamt:delete($hf,$eq,$hamtdel,"murphy")
let $hamtdel := hamt:delete($hf,$eq,$hamtdel,"noggin")
return (
  hamt:fold(function($z,$v) { $z, $v },(),$hamt4),
  hamt:describe($hamt),
  hamt:describe($hamt1),
  hamt:describe($hamt2),
  hamt:describe($hamt3),
  hamt:describe($hamt4),
  hamt:describe($hamtdel),
  hamt:get($hf,$eq,$hamt4,"noggin"),
  hamt:get($hf,$eq,$hamt4,"murphy"),
  hamt:get($hf,$eq,$hamt4,"jimbob"),
  hamt:count($hamt4),
  hamt:empty($hamt4),
  hamt:empty($hamt),
  hamt:empty($hamtdel)
)
