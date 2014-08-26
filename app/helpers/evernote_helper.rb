# Load libraries required by the Evernote OAuth
require 'oauth'
require 'oauth/consumer'
  
# Load Thrift & Evernote Ruby libraries
require 'evernote_oauth'

module EvernoteHelper
  def client
    @client ||= EvernoteOAuth::Client.new(token: auth_token, consumer_key: Settings.evernote_oauth_key, consumer_secret: Settings.evernote_oauth_secret, sandbox: Settings.evernote_sandbox)
  end

  def auth_token
    current_user.evernote_access_token if current_user
  end

  def user_store
    @user_store ||= client.user_store
  end
 
  def note_store
    @note_store ||= client.note_store
  end

  def en_user
    user_store.getUser(auth_token)
  end

  def notebooks
    @notebooks ||= note_store.listNotebooks(auth_token)
  end

  def total_note_count
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    counts = note_store.findNoteCounts(auth_token, filter, false)
    notebooks.inject(0) do |total_count, notebook|
      total_count + (counts.notebookCounts[notebook.guid] || 0)
    end
  end

  def save_to_evernote(document)
    template = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><p>{content}</p><en-media type="application/pdf" hash="{hash}" /></en-note>'

    raise "Not authorised." unless auth_token 

    filename = '/Users/lucas/Documents/Android intro.pdf'
    pdf = File.open(filename, "rb") { |io| io.read }

    hashFunc = Digest::MD5.new
    hashHex = hashFunc.hexdigest(pdf)

    data = Evernote::EDAM::Type::Data.new()
    data.size = pdf.size
    data.bodyHash = hashHex
    data.body = pdf;

    resource = Evernote::EDAM::Type::Resource.new()
    resource.mime = "application/pdf"
    resource.data = data;
    resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new()
    resource.attributes.fileName = filename.split('/').last

    note = Evernote::EDAM::Type::Note.new(
      title: "Yep. It's a note.", 
      content: template.gsub('{content}', params[:content]).gsub('{hash}', hashHex), active: true
    )
    note.resources = [ resource ]

    note_store.createNote(auth_token, note)
  end
end