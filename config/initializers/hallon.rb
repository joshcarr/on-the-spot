OnTheSpot::Application.setup_spotify!

# We use the Spotify URI quite a bit
# define a URI method on Hallon Track
# to make this a bit neater
Hallon::Track.class_eval do
  def uri
    self.to_link.to_str
  end

  def duration_string(format = "%-Mm %Ss")
    Time.at(self.duration).utc.strftime(format)
  end

  def cover_image
    self.album.cover.load
    "data:image/jpeg;base64,#{Base64.encode64(self.album.cover.data)}"
  end
end

