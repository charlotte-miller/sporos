# Defines the interface for a Media::Lesson::SimilarityHeuristic strategy.
# A Media::Lesson::SimilarityHeuristic answers the fuzzy-question "Does this lesson belong with this other_lesson?"
#
module Media::Lesson::SimilarityHeuristic
  class Base
    include ::ActsAsInterface
    abstract_methods :matches?

    attr_reader :context, :other_lesson
    def initialize(context, other_lesson)
      @context      = context
      @other_lesson = other_lesson
    end
  
    # Load STRATEGIES into a single array
    Dir.glob("#{__FILE__}/**/*").each {|file| require file}
    STRATEGIES = [
      Media::Lesson::SimilarityHeuristic::NumericTitle,
      Media::Lesson::SimilarityHeuristic::Subtitle,
    ]
  end
  
end