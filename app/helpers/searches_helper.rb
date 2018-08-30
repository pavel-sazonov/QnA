module SearchesHelper
  def result_handler(result)
    type = result.class.name
    case type
    when 'User'
      tag.div(result.email)
    when 'Question'
      tag.div(link_to result.title, question_path(result))
    else
      tag.div(type + ': ' + result.body.truncate(20))
    end
  end
end
