# TODO rewrite
module Support
  module DSL
    module ESearch

      def vim_let(var, value)
        vim.normal(":let #{var} = #{value}<Enter><Enter>")
      end

      def esearch_settings(options)
        pairs = options.map do |name, val|
          val = "'#{val}'" unless val.is_a? Numeric
          "'#{name}': #{val}"
        end
        dict = "{ #{pairs.join(',')} }"
        vim.normal(":if !exists('g:esearch') | let g:esearch = #{dict} | else | call extend(g:esearch, #{dict}) | endif<Enter><Enter>")
      end
    end
  end
end
