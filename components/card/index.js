import * as React from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import styles from '../../styles/Home.module.css'

const NameCard = ({title}) => {
  return (
    <div className={styles.card}>
      <Typography className={styles.cardContent}>
        {title}
      </Typography>
    </div>
  );
}

export default NameCard;