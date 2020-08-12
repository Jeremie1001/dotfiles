'use strict'

/**
 * Require the path without any caching.
 * @throws If the `require` call throws, we will throw it too.
 * @param {string} path The path to require.
 * @returns {any} The result of the `require` call
 */
function requireFresh(path) {
	// Resolve the path to the one used for the cache
	const resolvedPath = require('path').resolve(path)

	// Attempt require with removals of the cache
	delete require.cache[resolvedPath] // clear require cache for the config file
	const result = require(resolvedPath)
	delete require.cache[resolvedPath] // clear require cache for the config file

	// Return result
	return result
}

/**
 * Require Fresh Callback in typical errback style.
 * @callback RequireFreshCallback
 * @param {Error?} error If the `require` call threw, this is its error.
 * @param {any} path The result of the `require` call.
 */

/**
 * Require the path without any caching, but catch errors into the callback.
 * @param {string} path The path to require.
 * @param {RequireFreshCallback} next The errback callback.
 * @returns {void}
 */
function requireFreshSafe(path, next) {
	let result, error
	try {
		result = requireFresh(path)
	} catch (err) {
		error = err
	}
	next(error, result)
	// ^ error cannot be returned
	// ^ because what if the module intended to RETURN (not throw) an error
	// ^ hence why callback is only option here, as it can differentiate between returned and thrown errors
}

// Export and alias
requireFresh.safe = requireFreshSafe
module.exports = requireFresh
