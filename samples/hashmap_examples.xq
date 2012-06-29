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

import module namespace hmap = "http://snelson.org.uk/functions/hashmap" at "../hashmap.xq";

let $hashmap := hmap:create()
let $hashmap := fold-left(hmap:put#2, hmap:create(), (
  hmap:entry("a", "aardvark"),
  hmap:entry("z", "zebra"),
  hmap:entry("e", ("elephant", "eagle")),
  hmap:entry("o", "osterich"),
  hmap:entry("t", "terrapin"),
  hmap:entry("a", "antelope")
))
let $map := hmap:get($hashmap, ?)
return (
  $map("a"),
  $map("e"),
  hmap:contains($hashmap, "k"),

  hmap:fold(
    function($a, $k, $v) {
      $a, concat("key: ", $k, ", value: (",
        string-join($v, ", "), ")")
    }, (), $hashmap)
)
