import http from 'k6/http';
import { sleep, check } from 'k6';

export const options = {
  vus: 500,           
  duration: '200s',  
};

export default function () {
  const res = http.get('http://localhost:5000/users');

  check(res, {
    'status is 200': (r) => r.status === 200,
  });

  sleep(1);
}
