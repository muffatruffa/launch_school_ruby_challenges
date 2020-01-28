class BNode
  attr_reader :left, :right, :data

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def add_left(node_value)
    @left = self.class.new(node_value)
  end

  def add_right(node_value)
    @right = self.class.new(node_value)
  end
end

class Bst
  def initialize(data)
    @root = BNode.new(data)
  end

  def insert(data)
    add_at_node(@root, data)
  end

  def each(&block)
    bstree_enum.each(&block)
  end

  # left here just as example on a different way of implementing it
  # without Enumerator
  # def each(&block)
  #   return to_enum unless block_given?

  #   in_order_run_callable(@root, block)
  # end

  def data
    @root.data
  end

  def left
    @root.left
  end

  def right
    @root.right
  end

  private

  def in_order_run_callable(node, callable)
    in_order_run_callable(node.left, callable) if node.left
    callable.(node.data)
    in_order_run_callable(node.right, callable) if node.right
  end

  def add_at_node(node, node_value)
    if node_value <= node.data
      return node.add_left(node_value) unless node.left
      add_at_node(node.left, node_value)
    else
      return node.add_right(node_value) unless node.right
      add_at_node(node.right, node_value)
    end
  end

  def bstree_enum
    Enumerator.new do |y|
      send_to_yielder = proc { |node_data| y << node_data }
      in_order_run_callable(@root, send_to_yielder)
    end
  end

  # Just another example on using #in_order_run_callable
  def to_a
    result = []
    fill_result = proc { |node_data| result << node_data }
    in_order_run_callable(@root, fill_result)
    result
  end
end

if $PROGRAM_NAME == __FILE__
  four = Bst.new 4
  four.insert 2
  four.insert 1
  four.insert 3
  four.insert 6
  four.insert 7
  four.insert 5
  four.each { |n|  puts n * 2}
end