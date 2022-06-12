import styles from "../../styles/Home.module.css";
import * as React from "react";
import { styled } from "@mui/material/styles";
import Card from "@mui/material/Card";
import CardHeader from "@mui/material/CardHeader";
import CardMedia from "@mui/material/CardMedia";
import CardContent from "@mui/material/CardContent";
import CardActions from "@mui/material/CardActions";
import Collapse from "@mui/material/Collapse";
import Avatar from "@mui/material/Avatar";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import { red } from "@mui/material/colors";
import FavoriteIcon from "@mui/icons-material/Favorite";
import ShareIcon from "@mui/icons-material/Share";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import MoreVertIcon from "@mui/icons-material/MoreVert";
import { useState, useEffect } from "react";
import moment from "moment";

const ExpandMore = styled((props) => {
  const { expand, ...other } = props;
  return <IconButton {...other} />;
})(({ theme, expand }) => ({
  transform: !expand ? "rotate(0deg)" : "rotate(180deg)",
  marginLeft: "auto",
  transition: theme.transitions.create("transform", {
    duration: theme.transitions.duration.shortest,
  }),
}));

export default function EventCard({
  name,
  quantity,
  timestamp,
  location,
  temperature,
}) {
  const [expanded, setExpanded] = useState(false);
  const [items, setItems] = useState([]);

  var date = new Date(timestamp*1000).toLocaleString("en-US")

  const handleExpandClick = () => {
    setExpanded(!expanded);
  };

  return (
    <>
      <div className={styles.eventBottomCard}>
        <Card sx={{ width: 300 }}>
          <CardHeader title={name} subheader={location} />
          <CardActions sx={{ marginTop: -7 }}>
            <ExpandMore
              expand={expanded}
              onClick={handleExpandClick}
              aria-expanded={expanded}
              aria-label="show more"
            >
              <ExpandMoreIcon />
            </ExpandMore>
          </CardActions>
          <Collapse in={expanded} timeout="auto" unmountOnExit>
            <CardContent>
              <Typography className={styles.eventCardText}>
                Quantity: {quantity}
              </Typography>
              <Typography className={styles.eventCardText}>
                Temperature: {temperature}
              </Typography>
              <Typography className={styles.eventCardText}>
                Date: {date}
              </Typography>
            </CardContent>
          </Collapse>
        </Card>
      </div>
    </>
  );
}
