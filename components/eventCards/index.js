import * as React from "react";
import Typography from "@mui/material/Typography";
import styles from "../../styles/Home.module.css";

const EventCard = ({ location, temperature, time }) => {
  return (
    <>
      <div className={styles.eventCard}>
        <Typography className={styles.eventCardText}>
          Place : {location}
        </Typography>
        <Typography className={styles.eventCardText}>
          Temperature : {temperature}
        </Typography>
        <Typography className={styles.eventCardText}>Time : {time}</Typography>
      </div>
    </>
  );
};

export default EventCard;
