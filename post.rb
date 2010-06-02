#!/usr/bin/env ruby

require 'openssl'
require 'json'
require 'rest_client'

HOST = 'http://127.0.0.1'
PORT = 4567
SITE = "#{HOST}:#{PORT}"

CERTFILE = '/home/michael/Desktop/cert.pem'
KEYFILE = '/home/michael/Desktop/key.pem'

KEY = OpenSSL::PKey::RSA.new(File.read(KEYFILE))
CERT = OpenSSL::X509::Certificate.new(File.read(CERTFILE))

ARGV.each do |file|
  data = File.read(file).lines.to_a
  title = data.shift.strip
  body = data.join('').strip
  json = {:title => title, :body => body}.to_json
  sig = OpenSSL::PKCS7.sign(CERT, KEY, json)
  resp = RestClient.post SITE, :sig => sig, :data => json
  puts resp.body
end

