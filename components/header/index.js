import * as React from 'react';
import Typography from '@mui/material/Typography';
import styles from '../../styles/Home.module.css'

const Header = ({title}) => {
    return(
        <>
            <div className={styles.header}>
                {title}
            </div>
        </>
    );
}

export default Header;