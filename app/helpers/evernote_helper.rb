# Load libraries required by the Evernote OAuth
require 'oauth'
require 'oauth/consumer'
  
# Load Thrift & Evernote Ruby libraries
require 'evernote_oauth'

module EvernoteHelper
  def client
    @client ||= factory.evernote_client(auth_token)
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

  def mimetype_from_filetype(filetype)
    {
      'pdf' => 'application/pdf',
      'jpg' => 'image/jpeg',
      'tiff' => 'image/tiff'
    }[filetype.downcase]
  end

  def save_to_evernote(filename)
    template = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><p>{content}</p><en-media type="{mimetype}" hash="{hash}" /></en-note>'

    raise "Not authorised." unless auth_token 

    mimetype = mimetype_from_filetype(filename.split('.').last)

    content = File.open(filename, "rb") { |io| io.read }

    hashFunc = Digest::MD5.new
    hashHex = hashFunc.hexdigest(content)

    data = Evernote::EDAM::Type::Data.new()
    data.size = content.size
    data.bodyHash = hashHex
    data.body = content;

    resource = Evernote::EDAM::Type::Resource.new()
    resource.mime = mimetype
    resource.data = data;
    resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new()
    resource.attributes.fileName = filename.split('/').last

    note = Evernote::EDAM::Type::Note.new(
      title: "Note from Scant", 
      content: template.gsub('{content}', '').gsub('{hash}', hashHex).gsub('{mimetype}', mimetype), active: true
    )
    note.resources = [ resource ]

    note_store.createNote(auth_token, note)

    true
  end
end