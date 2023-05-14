import { QwikTable } from './components/qwikTable/QwikTable';
import tableData from './data.json';

export default () => {
  const headers = [
    { key: "id", label: "ID" },
    { key: "first_name", label: "First name" },
    { key: "last_name", label: "Last name" },
    { key: "email", label: "Email" },
    { key: "gender", label: "Gender" },
    { key: "ip_address", label: "IP address" },
  ];
  return (
    <>
      <head>
        <meta charSet="utf-8" />
        <title>Qwik Blank App</title>
      </head>
      <body>

      <QwikTable tableData={tableData} headers={headers} />

      </body>
    </>
  );
};
