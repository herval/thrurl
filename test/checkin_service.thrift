include "geo_types.thrift"

struct User {
  1: required i32 id
  2: optional string username
  3: optional map<string, bool> permissions
}

// basic track attributes required for figuring out if a track or playlist is visible to someone
struct Checkin {
    1: required User user
    2: required i32 timestamp
}


service CheckinService {

  map<geo_types.Location, list<Checkin>> checkinsPerLocation(1: User user)
  list<geo_types.Location> listLocations()

}