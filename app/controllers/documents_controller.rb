class DocumentsController < ApplicationController
  include DocumentsHelper
  include DropboxHelper
  include EvernoteHelper

  before_filter :check_user

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.for_user(current_user).order('created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])
    
    not_found unless current_user == @document.user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # POST /documents
  # POST /documents.json
  def create
    scan_options = {
      format: (params[:scan_format] || :jpg).to_sym,
      detail: (params[:scan_quality] || :rough).to_sym
    }

    filename = factory.scanner.scan(get_scan_name, scan_options)

    @document = Document.new(file_name: filename, quality: params[:scan_quality])
    @document.user = current_user

    dropbox_ok = (not params[:save_to_dropbox]) || save_to_dropbox(filename, current_user)
    evernote_ok = (not params[:save_to_evernote]) || save_to_evernote(filename)

    respond_to do |format|
      if @document.save and dropbox_ok
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
end
