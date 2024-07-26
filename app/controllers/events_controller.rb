class EventsController < ApplicationController
  before_action :authenticate_user!
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

  def event_params
    params.require(:event).permit(:name, :location, :date)
  end
end

