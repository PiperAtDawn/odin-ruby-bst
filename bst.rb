class Node
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    unique_sorted = array.uniq.sort
    finish = unique_sorted.size - 1
    @root = build_tree(unique_sorted, 0, finish)
  end

  def insert(data)
    self.root = insert_rec(data)
  end

  def insert_rec(data, node = root)
    unless node
      node = Node.new(data)
      return node
    end

    if data < node.data
      node.left = insert_rec(data, node.left)
    else
      node.right = insert_rec(data, node.right)
    end

    node
  end

  def delete(data)
    self.root = delete_rec(data)
  end

  def min_value(node = root)
    minv = node.data
    while node.left
      minv = node.left.data
      node = node.left
    end
    minv
  end

  def delete_rec(data, node = root)
    return node unless node

    if data < node.data
      node.left = delete_rec(data, node.left)
    elsif data > node.data
      node.right = delete_rec(data, node.right)
    else
      return nil unless node.left || node.right

      if !node.left
        return node.right
      elsif !node.right
        return node.left
      else
        node.data = min_value(node.right)
        node.right = delete_rec(node.data, node.right)
      end
    end
    node
  end

  def find(data, node = root)
    return node if !node || data == node.data

    find(data, node.left) || find(data, node.right)
  end

  def level_order(queue = [root], result = [], &block)
    cur = queue.shift
    return result unless cur

    queue << cur.left if cur.left
    queue << cur.right if cur.right
    result << (block_given? ? (yield cur) : cur.data)
    level_order(queue, result, &block)
  end

  def inorder(node = root, result = [], &block)
    depth_first('inorder', node, result, &block)
  end

  def preorder(node = root, result = [], &block)
    depth_first('preorder', node, result, &block)
  end

  def postorder(node = root, result = [], &block)
    depth_first('postorder', node, result, &block)
  end

  def height(node = root)
    return -1 unless node

    left_height = height(node.left)
    right_height = height(node.right)
    if left_height > right_height
      left_height + 1
    else
      right_height + 1
    end
  end

  def depth(node, root = self.root)
    return -1 unless root

    depth = -1
    if root == node ||
       (depth = depth(node, root.left)) >= 0 ||
       (depth = depth(node, root.right)) >= 0
      return depth + 1
    end

    depth
  end

  def balanced?(node = root)
    return true unless node

    left_height = height(node.left)
    right_height = height(node.right)

    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance
    array = inorder
    self.root = build_tree(array, 0, array.size - 1)
  end
  
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def build_tree(array, start, finish)
    return nil if start > finish

    middle = (start + finish) / 2
    node = Node.new(array[middle])
    node.left = build_tree(array, start, middle - 1)
    node.right = build_tree(array, middle + 1, finish)
    node
  end

  def depth_first(order, node, result, &block)
    return unless node

    result << (block_given? ? (yield node) : node.data) if order == 'preorder'
    depth_first(order, node.left, result, &block)
    result << (block_given? ? (yield node) : node.data) if order == 'inorder'
    depth_first(order, node.right, result, &block)
    result << (block_given? ? (yield node) : node.data) if order == 'postorder'
    result
  end
end

# Driver

def print_all_orders(tree)
  puts "Tree in level order: #{tree.level_order}."
  puts "Tree in preorder: #{tree.preorder}."
  puts "Tree in postorder: #{tree.postorder}."
  puts "Tree in order: #{tree.inorder}."
end

new_tree = Tree.new(Array.new(15) { rand(1..100) })
new_tree.pretty_print
puts new_tree.balanced? ? 'This tree is balanced.' : 'This tree is not balanced.'
print_all_orders(new_tree)

new_tree.insert(101)
new_tree.insert(102)
new_tree.insert(103)
new_tree.pretty_print
puts new_tree.balanced? ? 'This tree is balanced.' : 'This tree is not balanced.'

new_tree.rebalance
new_tree.pretty_print
puts new_tree.balanced? ? 'This tree is balanced.' : 'This tree is not balanced.'

print_all_orders(new_tree)
