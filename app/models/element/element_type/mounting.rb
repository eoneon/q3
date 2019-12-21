class Mounting < ElementBuild

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  def self.product_name
    ['on', element_name].join(' ')
  end

  ##############################################################################

  class TwoDimension < Mounting
    class OptionValue < TwoDimension
      def self.option
        %w[framed bordered matted wall-mount]
      end
    end
  end

  class CanvasMounting < Mounting
    class OptionValue < CanvasMounting
      def self.option
        ['framed', 'gallery wrapped', 'stretched', 'matted']
      end
    end
  end

  class BoxMounting < Mounting
    class OptionValue < BoxMounting
      def self.option
        ['gallery wrapped', 'box']
      end
    end
  end

  class SericelMounting < Mounting
    class OptionValue < SericelMounting
      def self.option
        %w[framed matted]
      end
    end
  end

  class ThreeDimension < Mounting
    class OptionValue < ThreeDimension
      def self.option
        %w[case base wall-mount stand]
      end
    end
  end

end
