class Dimension < ElementBuild

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  ##############################################################################

  #two-d material/mounting dimensions
  class WidthHeight < Dimension
    class OptionValue < WidthHeight
      def self.option
        %w[width height]
      end
    end
  end

  class Diameter < Dimension
    class OptionValue < Diameter
      def self.option
        %w[diamater]
      end
    end
  end

  class Depth < Dimension
    class OptionValue < Depth
      def self.option
        %w[depth]
      end
    end
  end

  #three-d: material dimensions
  class WidthHeightDepthWeight < Dimension
    class OptionValue < WidthHeightDepthWeight
      def self.option
        %w[width height depth weight]
      end
    end
  end

  class DiameterHeightWeight < Dimension
    class OptionValue < DiameterHeightWeight
      def self.option
        %w[diamater height weight]
      end
    end
  end

  class DiameterWeight < Dimension
    class OptionValue < DiameterWeight
      def self.option
        %w[diamater weight]
      end
    end
  end

  #three-d: mounting dimensions
  class WidthHeightDepth < Dimension
    class OptionValue < WidthHeightDepth
      def self.option
        %w[width height depth]
      end
    end
  end


end
