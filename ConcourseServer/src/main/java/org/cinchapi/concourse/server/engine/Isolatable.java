/*
 * The MIT License (MIT)
 * 
 * Copyright (c) 2013 Jeff Nelson, Cinchapi Software Collective
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.cinchapi.concourse.server.engine;

import org.cinchapi.common.annotate.PackagePrivate;
import org.cinchapi.common.multithread.Lock;

/**
 * An {@code Isolatable} store allows an external caller to lock records and
 * keys for serializable concurrency.
 * <em>The store does not, itself, automatically isolate
 * using the provided methods.</em>
 * 
 * @author jnelson
 */
@PackagePrivate
interface Isolatable {

	/**
	 * Returns a shared {@link Lock} for {@code record}.
	 * 
	 * @param record
	 * @return the Lock
	 */
	public Lock lockAndShare(long record);

	/**
	 * Returns a shared {@link Lock} for {@code key}.
	 * 
	 * @param key
	 * @return the Lock
	 */
	public Lock lockAndShare(String key);

	/**
	 * Returns a shared {@link Lock} for the field identified by
	 * {@code key} in {@code record}.
	 * 
	 * @param key
	 * @param record
	 * @return the Lock
	 */
	public Lock lockAndShare(String key, long record);

	/**
	 * Returns an exclusive {@link Lock} for the field identified by
	 * {@code key} in {@code record}.
	 * 
	 * @param key
	 * @param record
	 * @return the Lock
	 */
	public Lock lockAndIsolate(String key, long record);

}