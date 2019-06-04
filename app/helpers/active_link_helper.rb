module ActiveLinkHelper
  def match_link?(url)
    request.fullpath.match?(url)
  end

  def calendars_active_link?(namespace)
    regex = "^\/#{namespace}\/calendars(\/((tcc_one|tcc_two)(/search/page/\\d+)?|new|edit))?$"
    match_link?(regex) || calendars_history_active_link?(namespace)
  end

  def calendars_history_active_link?(namespace)
    route = "\/#{namespace}\/calendars\/\\d+/activities"
    match_link?(route) && calendar_from_history?
  end

  def calendar_from_history?
    !Calendar.current_calendar?(@calendar)
  end

  def orientations_active_link?(namespace)
    namespace = "\/#{namespace}\/orientations"
    regex = "^#{namespace}(\/((tcc_one|tcc_two)(/search/page/\\d+)?|new|\\d+|\\d+/edit))?$"
    match_link?(regex) && !Calendar.current_calendar?(@calendar)
  end

  def orientations_tcc_one_active_link?(namespace)
    match_link?("#{namespace}/orientations/current_tcc_one")
  end

  def orientations_tcc_two_active_link?(namespace)
    match_link?("#{namespace}/orientations/current_tcc_two")
  end

  def activities_tcc_active_link?(tcc_type, namespace)
    is_equal_tcc_type = @calendar && @calendar.tcc == tcc_type
    match_link?("/#{namespace}/calendars/\\d+/activities") && is_equal_tcc_type
  end

  def calendar_equal_current_calendar_tcc_one?
    calendar = @calendar || @orientation&.calendar
    current_calendar_tcc_one = Calendar.current_by_tcc_one
    return true if calendar.blank? || current_calendar_tcc_one.blank?
    calendar.id == current_calendar_tcc_one.id
  end

  def calendar_equal_current_calendar_tcc_two?
    calendar = @calendar || @orientation&.calendar
    current_calendar_tcc_two = Calendar.current_by_tcc_two
    return true if calendar.blank? || current_calendar_tcc_two.blank?
    calendar.id == current_calendar_tcc_two.id
  end

  def supervisions_tcc_one_or_two_active_link?(namespace)
    match_link?("^\/#{namespace}\/supervisions(\/((tcc_one|tcc_two)(\/search/page/\\d+)?))?$")
  end

  def supervisions_show_link?(namespace)
    match_link?("^\/#{namespace}\/supervisions\/\\d+$")
  end

  def supervisions_current_calendar_link?
    calendar = @orientation&.calendar
    Calendar.current_by_tcc_one?(calendar) || Calendar.current_by_tcc_two?(calendar)
  end

  def supervisions_active_link?(namespace)
    return true if supervisions_tcc_one_or_two_active_link?(namespace)
    supervisions_show_link?(namespace) && supervisions_current_calendar_link?
  end

  def supervisions_history_active_link?(namespace)
    match_link?("\/#{namespace}\/supervisions\/history") ||
      (supervisions_show_link?(namespace) && !supervisions_current_calendar_link?)
  end
end