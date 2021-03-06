#!/usr/bin/env ruby

require 'rubygems'
require 'openssl'
require 'json'
require 'rest_client'

HOST = 'http://127.0.0.1'
PORT = 4567

SITE = "#{HOST}:#{PORT}"

CONFIG = JSON.parse(File.read("#{ENV["HOME"]}/.blogidentity"))

EMAIL = CONFIG['email']
KEYFILE = CONFIG['keyfile']

KEY = OpenSSL::PKey::RSA.new(File.read(KEYFILE))

ARGV.each do |file|
  data = File.read(file).lines.to_a
  title = data.shift.strip
  body = data.join('').strip
  json = {:title => title, :body => body}.to_json

  hash = Digest::SHA256.hexdigest(json)

  cipher = OpenSSL::Cipher.new('AES256').encrypt
  cipher.key = hash
  cipher.iv = iv = cipher.random_iv

  encr = cipher.update(json)
  encr << cipher.final

  encr_hash = KEY.private_encrypt("#{iv}#{hash}")

  resp = RestClient.put SITE, :hash => encr_hash, :data => encr, :email => EMAIL
  puts resp.body
end

