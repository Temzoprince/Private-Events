class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
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

  def event_params
    params.require(:event).permit(:name, :location, :date)
  end
end

