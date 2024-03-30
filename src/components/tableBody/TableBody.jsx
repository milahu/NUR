import { component$, useComputed$, useStylesScoped$ } from '@builder.io/qwik';
import { isImage } from '../../utils/imageBool';













export const TableBody = component$((props) => {
  useStylesScoped$(AppCSS);

  const computedPosts = useComputed$(() => {
    const pageIdx = props.pageNo.value - 1;
    return props.data.slice((pageIdx * props.postPerPage.value),
      ((pageIdx * props.postPerPage.value)
        + parseInt(props.postPerPage.value.toString())))
  })

  /* Todo: removing this console.log results in a bug(searching and sorting simontaneously) */
  console.log(props.data.length);

  return (
    <tbody>
      {computedPosts.value.map(row => props.renderBodyRow(row))}
    </tbody>
  );
});

export const AppCSS = `
  tbody {
    color: #0f172a;
    font-size: 15px;
    letter-spacing: 0.3px;
  }
  img {
    object-fit: cover;
  }
`;
