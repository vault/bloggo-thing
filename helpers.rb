
helpers do
  # check if the signature was signed by 
  # the private key of the given public key
  def authentic? sig, pub_key
    sig.certificates[0].verify(pub_key)
  end

  # make sure the person is who they say they are
  def verify_authenticity!
    halt 400 unless params[:sig] && params[:data]
    sig = OpenSSL::PKCS7.new params[:sig]
    email = sig.signers[0].name.to_s.match(/emailAddress=(.*)\/?/)[1]
    @user = $DB.get email
    halt 403 unless @user[:pub_keys].any? do |key_str|
      key = OpenSSL::PKey::RSA.new(key_str)
      authentic? sig, key
    end
  end

  def sanitize_title title
    title.downcase.gsub(/[^a-z0-9]/, '-').squeeze('-').gsub(/^\-|\-$/, '')
  end
end

