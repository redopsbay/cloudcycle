package schedule

import (
	"errors"
	"github.com/redopsbay/cloudcycle/internal"
	"strconv"
	"time"
	"fmt"
)

// ValidForTermination indicates weather the provided parameter is for termination or not e.g expired!
func ValidForTermination(CreatedDate *time.Time) bool {
	currentDate := time.Now()
	if CreatedDate.Before(currentDate) {
		return true
	} else {
		return false
	}
}

// GetLifeCycle gets the correct specified duration for proper validation by adding timedelta depending on the tag suffix.
func GetLifeCycle(CreatedDate *time.Time, CloudCycle string) (*time.Time, error) {

	suffix := CloudCycle[len(CloudCycle)-1]
	prefix := CloudCycle[:len(CloudCycle)-1]

	lifecycle, err := strconv.Atoi(prefix)
	if err != nil {
		fmt.Println("Error:", err)
		return nil, err
	}

	if string(suffix) == string(internal.MinuteSuffix) {
		*CreatedDate = CreatedDate.Add(time.Minute * time.Duration(lifecycle))
	} else if string(suffix) == string(internal.HourSuffix) {
		*CreatedDate = CreatedDate.Add(time.Hour * time.Duration(lifecycle))
	} else if string(suffix) == string(internal.DaySuffix) {
		*CreatedDate = CreatedDate.Add(time.Hour * 24 * time.Duration(lifecycle))
	} else {
		return nil, errors.New("Unknown suffix")
	}

	return CreatedDate, nil
}
