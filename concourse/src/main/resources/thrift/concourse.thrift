# This file defines the RPC protocol for Concourse client/server interaction
# using Thrift. The services and resources that are defined in this file are
# not intended to be used by third parties, but they could be so they must meet
# high standards of quality.
#
# To generate java source code run:
# thrift -out ../../java -gen java concourse.thrift
#
# TODO IN ECLIPSE AFTER GENERATING (see THRIFT-2115)
# 1. Replace Hash with LinkedHash
# 2. Replace shared.AccessToken with AccessToken
# 3. Add @SuppressWarnings({ "rawtypes", "serial", "unchecked", "unused" }) to
#	 class
# 5. shift + command + F to format

include "data.thrift"
include "shared.thrift"

namespace java org.cinchapi.concourse.thrift

/**
 * The RPC protocol that forms the basis of cross-language client/server
 * communication in Concourse. This is considered a public API; however
 * it is intended to be wrapped in a more expressive APIs in the target
 * implementation language.
 */
service ConcourseService {

	/**
	 * Login to the service. A user must login to receive an {@link shared.AccessToken}
	 * which is required for all other method invocations.
	 */
	shared.AccessToken login(1: binary username, 2: binary password);

	/**
	 * Logout of the service and deauthorize {@code token}.
	 */
	void logout(1: shared.AccessToken token);

	/**
	 * Turn on {@code staging} mode so that all subsequent changes are collected
	 * in a staging area before possibly being committed to the database. Staged
	 * operations are guaranteed to be reliable, all or nothing units of work that
	 * allow correct  recovery from failures and provide isolation between clients
	 * so the database is always in a consistent state.
	 * <p>
	 * After this method returns, all subsequent operations will be done in
	 * {@code staging} mode until either {@link #abort(shared.AccessToken)} or
	 * {@link #commit(shared.AccessToken)} is invoked.
	 * </p>
	 */
	shared.TransactionToken stage(1: shared.AccessToken token);

	/**
	 * Abort and remove any changes that are currently sitting in the staging area.
	 * <p>
	 * After this function returns, all subsequent operations will commit to the
	 * database immediately until {@link #stage(shared.AccessToken)} is invoked.
	 * </p>
	 */
	void abort(1: shared.AccessToken creds, 2: shared.TransactionToken transaction);

	/**
	 * Attempt to permanently commit all the changes that are currently sitting in
	 * the staging area to the database. This function only returns {@code true}
	 * if all the changes can be successfully applied to the database. Otherwise,
	 * this function returns {@code false} and all the changes are aborted.
	 * <p>
	 * After this function returns, all subsequent operations will commit to the
	 * database immediately until {@link #stage(shared.AccessToken)} is invoked.
	 * </p>
	 */
	bool commit(1: shared.AccessToken creds, 2: shared.TransactionToken transaction);

	/**
	 * Add {@code key} as {@code value} to {@code record}. This method returns
	 * {@code true} if there is no mapping from {@code key} to {@code value}
	 * in {@code record} prior to invocation.
	 */
	bool add(1: string key, 2: data.TObject value, 3: i64 record, 4: shared.AccessToken creds,
		5: shared.TransactionToken transaction);

	/**
	 * Remove {@code key} as {@code value} from {@code record}. This method returns
	 * {@code true} if there is a mapping from {@code key} to {@code value} in
	 * {@code record} prior to invocation.
	 */
	bool remove(1: string key, 2: data.TObject value, 3: i64 record, 4: shared.AccessToken creds,
		5: shared.TransactionToken transaction);

	/**
	 * Audit {@code record} or {@code key} in {@code record}. This method returns a
	 * map from timestamp to a string describing the revision that occurred.
	 */
	map<i64,string> audit(1: i64 record, 2: string key, 3: shared.AccessToken creds,
		5: shared.TransactionToken transaction);

	/**
	 * Describe {@code record} at {@code timestamp}. This method returns keys for
	 * fields in {@code record} that contain at least one value at {@code timestamp}.
	 */
	set<string> describe(1: i64 record, 2: i64 timestamp, 3: shared.AccessToken creds,
		4: shared.TransactionToken transaction);

	/**
	 * Fetch {@code key} from {@code record} at {@code timestamp}. This method returns
	 * the values that exist in the field mapped from {@code key} at {@code timestamp}.
	 */
	set<data.TObject> fetch(1: string key, 2: i64 record, 3: i64 timestamp,
		4: shared.AccessToken creds, 5: shared.TransactionToken transaction);

	/**
	 * Find {@code key} {@code operator} {@code values} at {@code timestamp}. This
	 * method returns the records that match the criteria at {@code timestamp}.
	 */
	set<i64> find(1: string key, 2: shared.Operator operator, 3: list<data.TObject> values,
		4: i64 timestamp, 5: shared.AccessToken creds, 6: shared.TransactionToken transaction);

	/**
	 * Ping {@code record}. This method returns {@code true} if {@code record} has at
	 * least one populated field.
	 */
	bool ping(1: i64 record, 2: shared.AccessToken creds, 3: shared.TransactionToken transaction);

	/**
	 * Search {@code key} for {@code query}. This method returns the records that have
	 * a value matching {@code query} in the field mapped from {@code key}.
	 */
	set<i64> search(1: string key, 2: string query, 3: shared.AccessToken creds,
		4: shared.TransactionToken transaction);

	/**
	 * Verify {@code key} as {@code value} in {@code record} at {@code timestamp}. This
	 * method returns {@code true} if the field contains {@code value} at
	 * {@code timestamp}.
	 */
	bool verify(1: string key, 2: data.TObject value, 3: i64 record, 4: i64 timestamp,
		5: shared.AccessToken creds, 6: shared.TransactionToken transaction);

	/**
	 * Atomically revert {@code key} in {@code record} to {@code timestamp}.
	 */
	void revert(1: string key, 2: i64 record, 3: i64 timestamp, 4: shared.AccessToken creds,
		5: shared.TransactionToken token);

	/**
	 * Atomically clear {@code key} in {@code record} by removing every value that
	 * currently exists.
	 */
	void clear(1: string key, 2: i64 record, 3: shared.AccessToken creds,
		5: shared.TransactionToken token);

	/**
	 * Atomically set {@code key} as {@code value} in {@code record} by removing any
	 * values that currently exist and adding {@code value}.
	 */
	void set0(1: string key, 2: data.TObject value, 3: i64 record, 4: shared.AccessToken creds,
		5: shared.TransactionToken token);

	/**
	 * Atomically verify {@code key} as {@code expected} in {@code record} and swap
	 * with {@code replacement} if it exists.
 	 */
	bool verifyAndSwap(1: string key, 2: data.TObject expected, 3: i64 record,
		4: data.TObject replacement, 5: shared.AccessToken creds,
		6: shared.TransactionToken token);

	/**
	 * Return the release version of the server.
	 */
	string getServerVersion();
	
	/**
	  * Atomically add the key-value mappings defined in the {@code json} formatted 
	  * string to {@code record}.
	  */
	bool insert(1: string json, 2: i64 record, 3: shared.AccessToken creds, 
		4: shared.TransactionToken token);

}
