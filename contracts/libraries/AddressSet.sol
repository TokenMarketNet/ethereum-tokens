// Based on http://solidity.readthedocs.io/en/develop/contracts.html

library AddressSet {
  // We define a new struct datatype that will be used to
  // hold its data in the calling contract.
  struct Data { mapping(address=> bool) flags; }

  // Note that the first parameter is of type "storage
  // reference" and thus only its storage address and not
  // its contents is passed as part of the call.  This is a
  // special feature of library functions.  It is idiomatic
  // to call the first parameter 'self', if the function can
  // be seen as a method of that object.
  function insert(Data storage self, address value)
      returns (bool)
  {
      if (self.flags[value])
          return false; // already there
      self.flags[value] = true;
      return true;
  }

  function remove(Data storage self, address value)
      returns (bool)
  {
      if (!self.flags[value])
          return false; // not there
      self.flags[value] = false;
      return true;
  }

  function contains(Data storage self, address value)
      returns (bool)
  {
      return self.flags[value];
  }
}