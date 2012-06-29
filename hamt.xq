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

module namespace hamt = "http://snelson.org.uk/functions/hamt";
declare default function namespace "http://snelson.org.uk/functions/hamt";
import module namespace data = "http://snelson.org.uk/functions/data" at "lib/data.xq";

declare %private variable $hamt:width := 32;
declare %private variable $hamt:depth := 4;

declare %private variable $hamt:type := data:declare(
<HAMT>
  <Empty/>
  <Leaf><data:Sequence/><data:Sequence/></Leaf>
  <Seq><data:Sequence/></Seq>
  <Index><HAMT occurrence="*"/></Index>
</HAMT>, (: type check :)fn:false());
declare %private variable $hamt:empty := $hamt:type[1]();
declare %private variable $hamt:empty-index := index((1 to $hamt:width) ! $hamt:empty);
declare %private variable $hamt:leaf := $hamt:type[2];
declare %private variable $hamt:seq := $hamt:type[3];
declare %private variable $hamt:index := $hamt:type[4];
declare %private function leaf($k,$hash) { $hamt:leaf($k,$hash) };
declare %private function seq($values) { $hamt:seq($values) };
declare %private function index($children) { $hamt:index($children) };

declare function is($hamt)
{
  fn:node-name(data:type($hamt)/..) eq xs:QName("HAMT")
};

declare function type-check($hamt)
{
  if(is($hamt)) then () else
  fn:error(xs:QName("hamt:BADTYPE"),"Not a HAMT value")
};

declare function create() { $hamt:empty };

declare function put($hf,$eq,$hamt,$k)
{
  type-check($hamt),
  put-helper($eq,$hamt:depth,$hamt,$k,$hf($k))
};

declare %private function put-helper($eq,$depth,$hamt,$k,$hash)
{
  data:match($hamt,
    (: Empty :) function() {
      if($depth eq 0) then seq($k)
      else leaf($k,$hash)
    },
    (: Leaf :) function($v,$vhash) {
      if($eq($v,$k)) then leaf($k,$hash)
      else if($depth eq 0) then seq(($k,$v))
      else $hamt:empty-index
        ! put-helper($eq,$depth,.,$v,$vhash)
        ! put-helper($eq,$depth,.,$k,$hash)
    },
    (: Seq :) function($values) {
      seq(($k,$values[fn:not($eq(.,$k))]))
    },
    (: Index :) function($children) {
      index(
        let $i := ($hash mod $hamt:width) + 1
        let $hashleft := $hash idiv $hamt:width
        for $c at $p in $children
        return
          if($p ne $i) then $c
          else put-helper($eq,$depth - 1,$c,$k,$hashleft)
      )
    }
  )
};

declare function delete($hf,$eq,$hamt,$k)
{
  type-check($hamt),
  delete-helper($eq,$hamt,$k,$hf($k))
};

declare %private function delete-helper($eq,$hamt,$k,$hash)
{
  data:match($hamt,
    (: Empty :) function() { $hamt:empty },
    (: Leaf :) function($v,$vhash) {
      if($eq($v,$k)) then $hamt:empty else $hamt
    },
    (: Seq :) function($values) {
      let $newvalues := $values[fn:not($eq(.,$k))]
      return if(fn:empty($newvalues)) then $hamt:empty else seq($newvalues)
    },
    (: Index :) function($children) {
      let $newindex := index(
        let $i := ($hash mod $hamt:width) + 1
        let $hashleft := $hash idiv $hamt:width
        for $c at $p in $children
        return
          if($p ne $i) then $c
          else delete-helper($eq,$c,$k,$hashleft)
      )
      return if(empty-helper($newindex)) then $hamt:empty else $newindex
    }
  )
};

declare function get($hf,$eq,$hamt,$k)
{
  type-check($hamt),
  get-helper($eq,$hamt,$k,$hf($k))
};

declare function contains($hf,$eq,$hamt,$k)
{
  fn:exists(get($hf,$eq,$hamt,$k))
};

declare %private function get-helper($eq,$hamt,$k,$hash)
{
  data:match($hamt,
    (: Empty :) function() {
      ()
    },
    (: Leaf :) function($v,$vhash) {
      if($eq($v,$k)) then $k else ()
    },
    (: Seq :) function($values) {
      $values[$eq(.,$k)]
    },
    (: Index :) function($children) {
      let $i := ($hash mod $hamt:width) + 1
      let $hashleft := $hash idiv $hamt:width
      return get-helper($eq,$children[$i],$k,$hashleft)
    }
  )
};

declare function describe($hamt)
{
  type-check($hamt),
  data:describe($hamt)
};

declare function fold($f,$z,$hamt)
{
  type-check($hamt),
  fold-helper($f,$z,$hamt)  
};

declare %private function fold-helper($f,$z,$hamt)
{
  data:match($hamt,
    (: Empty :) function() { $z },
    (: Leaf :) function($v,$vhash) { $f($z,$v) },
    (: Seq :) fn:fold-left($f,$z,?),
    (: Index :) fn:fold-left(fold-helper($f,?,?),$z,?)
  )
};

declare function count($hamt)
{
  type-check($hamt),
  count-helper($hamt)  
};

declare %private function count-helper($hamt)
{
  data:match($hamt,
    (: Empty :) function() { 0 },
    (: Leaf :) function($v,$vhash) { 1 },
    (: Seq :) fn:count#1,
    (: Index :) fn:fold-left(function($z,$c) { $z + count-helper($c) },0,?)
  )
};

declare function empty($hamt)
{
  type-check($hamt),
  empty-helper($hamt)
};

declare %private function empty-helper($hamt)
{
  data:match($hamt,
    (: Empty :) fn:true#0,
    (: Leaf :) function($v,$vhash) { fn:false() },
    (: Seq :) fn:empty#1,
    (: Index :) fn:fold-left(function($z,$c) { $z and empty-helper($c) },fn:true(),?)
  )
};
