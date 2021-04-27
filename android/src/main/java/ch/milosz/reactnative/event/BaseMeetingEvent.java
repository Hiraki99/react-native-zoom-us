package ch.milosz.reactnative.event;

public abstract class BaseMeetingEvent {

  public final String event;

  protected BaseMeetingEvent(String event) {
    this.event = event;
  }

  public String getEvent() {
    return event;
  }
}
