require 'nokogiri'
require 'faraday'
require 'json'
require 'csv'

if ARGV.length < 2
  puts 'Please provide the ORCID client_id and client_secret, like this: ruby orcid.rb ID SECRET'
else

  client_id = ARGV[0]
  client_secret = ARGV[1]

# get the orcid xml for each orcid in the file
  orcids_list = CSV.read("orcids.csv", {:headers => false})
  fl = File.open("unclaimed-orcids.csv", "w+")
  fc = File.open("claimed-orcids.csv", "w+")

# write header row
  fl.write('orcid,first,last,dept,creation method')
  fl.write("\n")
  fc.write('orcid,first,last,dept,creation method')
  fc.write("\n")

  conn = Faraday.new(:url => 'https://api.orcid.org') do |faraday|
    faraday.request :url_encoded # form-encode POST params
    faraday.response :logger # log requests to STDOUT
    faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
  end

  response = conn.post '/oauth/token', {
      :client_id => client_id,
      :client_secret => client_secret,
      :scope => "/read-public",
      :grant_type => "client_credentials"
  }

  token = JSON.parse(response.body)['access_token']

  conn = Faraday.new(:url => 'https://pub.orcid.org') do |faraday|
    faraday.request :url_encoded # form-encode POST params
    faraday.response :logger # log requests to STDOUT
    faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
  end

  orcids_list.each_with_index do |o, index|
    orcid = o[2]

    puts "Checking number #{index}, #{o[1]} (#{o[2]})"

    response = conn.get do |req|
      req.url '/v1.2/' + orcid
      req.headers['Content-Type'] = 'application/orcid+xml'
      req.headers['Authorization'] = 'Bearer ' + token
    end

    orcid_xml = response.body

    @doc = Nokogiri::XML(orcid_xml)

    line = orcid + ','

    @doc.css('orcid-message orcid-profile').each do |i|

      i.css('orcid-bio personal-details given-names').each do |g|
        line += g.text + ','
      end

      i.css('orcid-bio personal-details family-name').each do |s|
        line += s.text + ','
      end

      line += o[0] + ','

      i.css('orcid-history creation-method').each do |c|
        line += c.text
      end

      i.css('orcid-history claimed').each do |c|
        if c.text == 'false'
          fl.write(line + "\n")
        else
          fc.write(line + "\n")
        end
      end
    end

  end

  fl.close
  fc.close

end