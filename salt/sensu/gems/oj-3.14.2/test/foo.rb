#!/usr/bin/env ruby

$: << '.'
$: << File.join(File.dirname(__FILE__), "../lib")
$: << File.join(File.dirname(__FILE__), "../ext")

require "oj"

class Stuff
  attr_accessor :alpha, :bravo, :charlie, :delta, :echo, :foxtrot, :golf, :hotel, :india, :juliet
  def self.json_create(arg)
    obj = self.new
    obj.alpha = arg["alpha"]
    obj.bravo = arg["bravo"]
    obj.charlie = arg["charlie"]
    obj.delta = arg["delta"]
    obj.echo = arg["echo"]
    obj.foxtrot = arg["foxtrot"]
    obj.golf = arg["golf"]
    obj.hotel = arg["hotel"]
    obj.india = arg["india"]
    obj.juliet = arg["juliet"]
    obj
  end
end

$obj_json = %|{
  "alpha": [0, 1,2,3,4,5,6,7,8,9],
  "bravo": true,
  "charlie": 123,
  "delta": "some string",
  "echo": null,
  "^": "Stuff",
  "foxtrot": false,
  "golf": "gulp",
  "hotel": {"x": true, "y": false},
  "india": [null, true, 123],
  "juliet": "junk"
}|

def parse(json)
  p_usual = Oj::Parser.new(:usual)
  p_usual.cache_keys = true
  p_usual.cache_strings = (p_usual.cache_keys ? 6 : 0)
  p_usual.symbol_keys = true
  p_usual.create_id = '^'
  p_usual.class_cache = true
  p_usual.ignore_json_create = true

  p_usual.parse(json)
  nil
end

parse($obj_json)

Oj.mem_report()

Oj.mem_report()
