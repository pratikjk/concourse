/*
 * This project is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 * 
 * This project is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this project. If not, see <http://www.gnu.org/licenses/>.
 */
package com.cinchapi.concourse.core;

import com.cinchapi.concourse.io.ByteSized;

/**
 * <p>
 * A {@link ByteSized} object that is stored within a {@link Container}.
 * </p>
 * <p>
 * Each {@code Bucketable} object is versioned by a unique timestamp. The
 * timestamp is stored directly with the object so that the version information
 * does not change when the object's storage context changes (i.e. when the
 * write buffer is flushed, when data is replicated, or when shards are
 * re-balanced, etc).
 * </p>
 * 
 * @author jnelson
 */
public interface Containable extends ByteSized {

	/**
	 * Represents a null timestamp, indicating the object is notForStorage.
	 */
	public static final long NIL = 0L;

	/**
	 * This method does not take timestamp into account because it is expected
	 * that there will be instances when two objects have different timestamps
	 * but are otherwise equal and should be treated as such. The associated
	 * #timestamp is meant to version the object and not necessarily to alter
	 * its essence in relation to other objects outside of temporal sorting.
	 */
	@Override
	public boolean equals(Object obj);

	/**
	 * This method does not take timestamp into account because it is expected
	 * that there will be instances when two objects have different timestamps
	 * but otherwise hash to the same value and should be treated as such. The
	 * associated #timestamp is meant to version the object and not necessarily
	 * to alter its essence in relation to other objects outside of temporal
	 * sorting.
	 * 
	 * @return
	 */
	@Override
	public int hashCode();

	/**
	 * Return the associated {@code timestamp}. This is guaranteed to be unique
	 * amongst forStorage values so it a defacto identifier. For notForStorage
	 * objects, the timestamp is always {@link #NIL}.
	 * 
	 * @return the {@code timestamp}
	 */
	public long getTimestamp();

	/**
	 * Return {@code true} if the object is suitable for use in storage
	 * functions.
	 * 
	 * @return {@code true} of {@link #isNotForStorage()} is {@code false}.
	 */
	boolean isForStorage();

	/**
	 * Return {@code true} if the object is not suitable for storage functions
	 * and is only suitable for comparisons.
	 * 
	 * @return {@code true} if the timestamp is {@link #NIL}.
	 */
	boolean isNotForStorage();

}