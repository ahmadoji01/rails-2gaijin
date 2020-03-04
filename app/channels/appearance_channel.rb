class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance_channel"
    current_user.online = true
    current_user.save

    ActionCable.server.broadcast("appearance_channel", {type: "CO_USER", user: current_user.id.to_s})
  end

  def unsubscribed
  	current_user.online = false
    current_user.save

    ActionCable.server.broadcast("appearance_channel", {type: "DC_USER", user: current_user.id.to_s})
  end
end
