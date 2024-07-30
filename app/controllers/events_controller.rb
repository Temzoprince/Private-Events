class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_event, only: [:destroy]
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: 'Event was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @event && @event.creator == current_user
      @event.destroy
      redirect_to current_user, notice: 'Event was successfully deleted'
    else
      redirect_to current_user, notice: 'There was a problem deleting this event'
    end
  end

  def attend
    @event = Event.find(params[:id])
    attendance = @event.attendances.build(attendee: current_user)
    if attendance.save
      redirect_to @event, notice: 'You have successfully reserved a spot at this event'
    else
      Rails.logger.debug attendance.errors.full_messages.to_sentence
      redirect_to @event, notice: 'There was a problem reserving a spot at this event'
    end
  end

  def unattend
    @event = Event.find(params[:id])
    attendance = @event.attendances.find_by(attendee: current_user)
    if attendance
      attendance.destroy
      redirect_to @event, notice: 'You have successfully revoked your reservation at this event'
    else
      Rails.logger.debug attendance.errors.full_messages.to_sentence
      redirect_to @event, notice: 'There was a problem revoking your reservation at this event'
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])

    unless @event
      redirect_to events_url, alert: 'Event not found'
    end
  end

  def event_params
    params.require(:event).permit(:name, :location, :date)
  end
end

