class StorageController < ApplicationController

  before_filter   :secure_controller
  skip_before_filter :verify_authenticity_token
  
  def index
  end

  def browser
    @folder = params[:folder]
    if not @folder
      @folder = StorageFolder.find_by_sql ["
      SELECT storage_folders.* FROM storage_folders
        JOIN permissions ON storage_folders.id = permissions.object_id
          AND permissions.object_type = 'StorageFolder' AND permissions.granted = ?
          AND permissions.active = ?
        JOIN memberships ON permissions.group_id = memberships.group_id
          AND memberships.user_id = ? AND memberships.active = ?
        WHERE storage_folders.parent_id IS NULL
        ", true, true, @user, true]
    else
      @folder = StorageFolder.find_by_sql ["
      SELECT storage_folders.* FROM storage_folders
        JOIN permissions ON storage_folders.id = permissions.object_id
          AND permissions.object_type = 'StorageFolder' AND permissions.granted = ?
          AND permissions.active = ?
        JOIN memberships ON permissions.group_id = memberships.group_id
          AND memberships.user_id = ? AND memberships.active = ?
        WHERE storage_folders.id = ?
        ", true, true, @user, true, @folder]
    end
    @folder = @folder[0]
    @folders = StorageFolder.find_by_sql ["
      SELECT storage_folders.* FROM storage_folders
        JOIN permissions ON storage_folders.id = permissions.object_id
          AND permissions.object_type = 'StorageFolder' AND permissions.granted = ?
          AND permissions.active = ?
        JOIN memberships ON permissions.group_id = memberships.group_id
          AND memberships.user_id = ? AND memberships.active = ?
        WHERE storage_folders.parent_id = ?
      ", true, true, @user, true, @folder]
    @files = StorageFolder.find_by_sql ["
      SELECT storage_files.* FROM storage_files
        JOIN permissions ON storage_files.id = permissions.object_id
          AND permissions.object_type = 'StorageFile' AND permissions.granted = ?
          AND permissions.active = ?
        JOIN memberships ON permissions.group_id = memberships.group_id
          AND memberships.user_id = ? AND memberships.active = ?
        WHERE storage_files.folder_id = ?
      ", true, true, @user, true, @folder]
  end

  def upload
    type = params[:id]
    @folder = params[:folder]
    # Load file
    @file = params[:upload]['file']
    # Path to folder containing user's files
    @path = File.join(DATA_ROOT,'storage','User', @user.username)
    # Original name of file
    @filename = @file.original_filename
    # Name for storage
    @temp = Digest::SHA1.hexdigest "#{@filename}#{Date.new}"
    # Full path to file
    @filepath = File.join(@path, @temp)
    # Create path if not exists
    FileUtils.mkdir_p @path
    # Copy file to storage
    FileUtils.copy(@file.path, @filepath)
    # Create virtual file
    file = StorageFile.new
    file.name = @filename
    file.file = @temp
    file.size = File.size(@file)
    file.type = ""
    file.folder_id = @folder
    file.save
    # Add permission
    perm = Permission.new
    perm.granted = true
    perm.group = Group.find :first, :conditions => { :owner_id => @user, :owner_type => 'User', :type_id => 3}
    perm.right = Right.find :first, :conditions => { :keyword => "own" }
    perm.object = file
    perm.active = true
    perm.save
    # Redirect back
    if type == "api"
      render :text => file.to_json
    else
      redirect_to :back
    end
  end

  def download
    @file = params[:id]
    @file = StorageFile.find :first, :conditions => { :id => @file }
    response.headers['X-Accel-Redirect'] = "/_data/storage/User/#{@user.username}/#{@file.file}"
    response.headers['Content-Disposition'] = "attachment; filename=#{@file.name}"
    response.headers['Content-Length'] = @file.size.to_s
    response.headers['Content-Type'] = 'application/force-download'
  end

  def newfolder
    folder = StorageFolder.new
    folder.name = params[:name]
    folder.parent = StorageFolder.find params[:parent]
    folder.save
    perm = Permission.new
    perm.granted = true
    perm.group = Group.find :first, :conditions => { :owner_id => @user, :owner_type => 'User', :type_id => 3}
    perm.right = Right.find :first, :conditions => { :keyword => "own" }
    perm.object = folder
    perm.active = true
    perm.save
    render :text => 'OK'
  end

end
