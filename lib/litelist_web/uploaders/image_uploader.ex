defmodule Litelist.ImageUploader do
    @moduledoc """
    Arc image uploader
    """
    use Arc.Definition
  
    # Include ecto support (requires package arc_ecto installed):
    use Arc.Ecto.Definition
  
    def __storage, do: Arc.Storage.Local
    
    @versions [:original, :thumb]
  
    # To add a thumbnail version:
    # @versions [:original, :thumb]
  
    # Whitelist file extensions:
    def validate({file, _}) do
      ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
    end
  
    # Define a thumbnail transformation:
    def transform(:thumb, _) do
      {:convert, "-strip -thumbnail 400x400^ -gravity center -extent 400x400 -format png", :png}
    end
  
    # Override the persisted filenames:
    # def filename(version, file_tuple) do
    #   first_obj = elem(file_tuple, 0)
    #   UUID.uuid3(:url, first_obj.file_name)
    # end
  
    # Override the storage directory:
    # def storage_dir(version, {file, scope}) do
    #   "uploads/#{UUID.uuid4()}"
    # end
  
    # Provide a default URL if there hasn't been a file uploaded
    # def default_url(version, scope) do
    #   "/images/avatars/default_#{version}.png"
    # end
  
    # Specify custom headers for s3 objects
    # Available options are [:cache_control, :content_disposition,
    #    :content_encoding, :content_length, :content_type,
    #    :expect, :expires, :storage_class, :website_redirect_location]
    #
    # def s3_object_headers(version, {file, scope}) do
    #   [content_type: Plug.MIME.path(file.file_name)]
    # end
  end
  