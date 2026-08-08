-- src/raymonds_algorithm.ads
-- Specification for Raymond's Tree-Based Distributed Mutual Exclusion Algorithm

package Raymonds_Algorithm is

   -- Strong typing for Algorithm Data
   type Node_Id is new Natural;
   Null_Node : constant Node_Id := 0;

   -- Message types exchanged in the tree topology
   type Message_Type is (Request_Msg, Token_Msg);

   type Message is record
      Kind     : Message_Type;
      Sender   : Node_Id;
      Receiver : Node_Id;
   end record;


   -- Fixed-size circular queue for Node requests
   Max_Queue : constant := 100;

   -- Bounded arrays to avoid dynamic allocation in critical systems
   type Message_List is array (1 .. 10) of Message;
   type Node_Id_List is array (1 .. Max_Queue) of Node_Id;

   type Message_Buffer is record
      Messages : Message_List;
      Count    : Natural := 0;
   end record;

   type Node_Queue is record
      Data  : Node_Id_List := (others => Null_Node);
      Front : Positive := 1;
      Rear  : Natural := 0;
      Count : Natural := 0;
   end record;

   -- Core Node State defined by Raymond's Algorithm
   type Node_State is record
      Id       : Node_Id := Null_Node;
      Holder   : Node_Id := Null_Node; -- Points toward the token holder
      Using_CS : Boolean := False;     -- True if actively in Critical Section
      Asked    : Boolean := False;     -- True if a request was sent upward
      Req_Q    : Node_Queue;           -- FIFO queue for incoming requests
   end record;

   Queue_Overflow  : exception;
   Queue_Underflow : exception;

   -- ==========================================
   -- Helper Functions (Queue & Messages)
   -- ==========================================
   procedure Enqueue (Q : in out Node_Queue; Item : Node_Id);
   procedure Dequeue (Q : in out Node_Queue; Item : out Node_Id);
   function Is_Empty (Q : Node_Queue) return Boolean;
   procedure Add_Message (Buffer : in out Message_Buffer; Msg : Message);

   -- ==========================================
   -- Variant 1: Standard Raymond's Algorithm
   -- ==========================================
   procedure Initialize (Node : in out Node_State; Id : Node_Id; Holder : Node_Id);
   procedure Request_CS (Node : in out Node_State; Out_Msgs : in out Message_Buffer);
   procedure Release_CS (Node : in out Node_State; Out_Msgs : in out Message_Buffer);
   procedure Receive_Request (Node : in out Node_State; From : Node_Id; Out_Msgs : in out Message_Buffer);
   procedure Receive_Token (Node : in out Node_State; Out_Msgs : in out Message_Buffer);

   -- Internal state transition (Exposed for strict unit testing)
   procedure Assign_Token (Node : in out Node_State; Out_Msgs : in out Message_Buffer);

   -- ==========================================
   -- Variant 2: Greedy / Piggybacked Protocol
   -- ==========================================
   -- Suppresses duplicate network requests if a node is already queued.
   procedure Greedy_Receive_Request (Node : in out Node_State; From : Node_Id; Out_Msgs : in out Message_Buffer);

end Raymonds_Algorithm;
