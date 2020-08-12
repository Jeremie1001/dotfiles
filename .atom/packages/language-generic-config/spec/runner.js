'use strict'

const {createRunner} = require('atom-mocha-test-runner')
global.expect = require('chai').expect

module.exports = createRunner({
  testSuffixes: ['spec.js', 'spec.coffee']
})
