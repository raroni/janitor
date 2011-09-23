module.exports =
  assert_equal: (val1, val2) ->
    @store_assert 'equal', val1 == val2, {val1, val2}
    
  assert: (exp) ->
    @store_assert 'true', exp, {exp}
