--------------------------- MODULE raftConstants ---------------------------

EXTENDS Naturals, FiniteSets, Sequences, TLC

\* The set of server IDs
CONSTANTS Server

\* The set of client requests that can go into the log
CONSTANTS Value

\* Server states.
CONSTANTS Follower, Candidate, Leader, Switch 

\* A reserved value.
CONSTANTS Nil

\* Message types:
CONSTANTS RequestVoteRequest, RequestVoteResponse,
          AppendEntriesRequest, AppendEntriesResponse

\* for instrumentation to limit model state space
CONSTANTS MaxClientRequests

\* Maximum times a server can become a leader
CONSTANTS MaxBecomeLeader

\* Maximum term number allowed in the model
CONSTANTS MaxTerm

\*---------------------------------------------------------------------------
\*  New message kinds                                                         
\*---------------------------------------------------------------------------
CONSTANTS ClientPayload,     \* client -> server, carries large request value
          RecoveryRequest,   \* follower -> any, ask for <<idx,term>> payload
          RecoveryResponse   \* peer -> follower, ships missing payload


\* index into Server
VARIABLE switchIndex


\* Temporary storage for requests received by the switch before they're ordered
\* Maps request value to the full payload entry
VARIABLE switchBuffer


\* Each server's buffer of unordered requests received from the switch
\* Maps from Server to a set of request values pending ordering
VARIABLE unorderedRequests

\* Records which <<value, term>> pairs the current switch has sent to each server.
\* Maps Server ID -> Set of <<Value, Term>> pairs.
VARIABLE switchSentRecord

=============================================================================
\* Created by Ovidiu-Cristian Marcu