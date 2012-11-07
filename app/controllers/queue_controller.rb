# http://stackoverflow.com/questions/4536855/integer-ordinalization-in-ruby-rails
require 'active_support/core_ext/integer/inflections'

class QueueController < ApplicationController

  def current
    @current = QueuedTrack.find($redis.get("currently_playing"))
    render :json => {} and return unless @current
    render :json => {:name => @current.name, :image_data => @current.cover_image}
  end

  def index
    @current = QueuedTrack.find($redis.get("currently_playing"))
    @next    = QueuedTrack.upcoming(3)

    render
  end

  def create
    queued = QueuedTrack.create(params[:uri])
    if queued
      flash.now[:success] = I18n.t('queue.create.success', :position => queued.ordinalize)
    else
      flash.now[:error] = I18n.t('queue.create.failure')
    end

    render
  end

  def upvote
    QueuedTrack.upvote!(params[:id])
    redirect_to root_path
  end

  def clear

    # Clear the queue
    $redis.del QueuedTrack.queue_name
    $redis.del PreviousTrack.queue_name

    flash[:success] = I18n.t('queue.clear.success')
    redirect_to root_path
  end
end
