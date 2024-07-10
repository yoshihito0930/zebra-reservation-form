import React, { useState } from 'react';
import { useForm, Controller } from 'react-hook-form';
import './ReservationForm.css'; 

const ReservationForm = () => {
  const {
    handleSubmit,
    register,
    formState: { errors },
  } = useForm();

  const [isSubmitted, setIsSubmitted] = useState(false);
  const [isError, setIsError] = useState(false);

  const [nameError, setNameError] = useState(null);
  const [phoneNumberError, setPhoneNumberError] = useState(null);
  const [addressError, setAddressError] = useState(null);
  const [photographerNameError, setPhotographerNameError] = useState(null);
  const [emailError, setEmailError] = useState(null);
  const [preferredDateTimeError, setPreferredDateTimeError] = useState(null);
  const [stealDetailError, setStealDetailError] = useState(null);
  const [numberOfPeopleError, setNumberOfPeopleError] = useState(null);

  const apiGatewayUrl = 'https://tj3alvdeza.execute-api.ap-northeast-1.amazonaws.com/development/send';

  const onBlurField = (fieldName) => {
    switch (fieldName) {
      case 'name':
        setNameError(errors.name ? errors.name.message : null);
        break;
      case 'email':
        setEmailError(errors.email ? errors.email.message : null);
        break;
      case 'phoneNumber':
        setPhoneNumberError(errors.phoneNumber ? errors.phoneNumber.message : null);
        break;
      case 'address':
        setAddressError(errors.address ? errors.address.message : null);
        break;
      case 'photographerName':
        setPhotographerNameError(errors.photographerName ? errors.photographerName.message : null);
        break;
      case 'preferredDateTime':
        setPreferredDateTimeError(errors.preferredDateTime ? errors.preferredDateTime.message : null);
        break;
      case 'stealDetail':
        setStealDetailError(errors.stealDetail ? errors.stealDetail.message : null);
        break;
      default:
        break;
    }
  };

  const onSelectNumberOfPeople = (e) => {
    const selectedValue = e.target.value;

    // 'selectNumber' が選択されているかをチェック
    const isValidSelection = selectedValue !== 'selectNumber';

    if (!isValidSelection) {
      setNumberOfPeopleError('ご利用人数を選択してください');
    } else {
      setNumberOfPeopleError(null);
    }
  };

  const onSubmit = async(data) => {
  // リクエストデータを準備
    const requestData = {
      body: JSON.stringify(data),
      httpMethod:'POST',
      resource: '/send'
    };

    console.log('Sending HTTP request:', JSON.stringify(requestData));

  // フォームが送信されたときの処理
    try {
      const response = await fetch(apiGatewayUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestData),
      });
  
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
  
      // フォームが送信されたときの処理
      console.log('フォームが送信されました');
      setIsSubmitted(true);
    } catch (error) {
      console.error('There was an error:', error);
      // エラーが発生した場合、エラーページを表示する
      setIsError(true);
    }
  };

  const isFormValid = Object.keys(errors).length === 0; // 全てのエラーがないことを確認

  return (
    <div>
      {!isSubmitted && !isError && (
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className='background-container'>
          <div className='title'>
            <p className='uper-title'>スタジオゼブラ ご予約フォーム</p>
            <p className='under-title'>本予約および仮予約のお申し込みを承ります。</p>
          </div>

          <div className='how-reserve-container'>
            <p>- ご予約方法 -</p>
            <ol>
                <li>メールフォームに必要事項をご記載のうえ、お申し込みをお願いします。</li>
                <li>自動返信メールが届きましたら、受付担当者からのメール返信をお待ちください。<br />担当者からの返信をもってご予約の受付完了とさせていただきます。</li>
            </ol>
          </div>
          
          <div className='waring-container'>
            <p>- 注意事項- </p>
            <ul>
                <li>6時間以内に返信メールがない場合はお手数ですがご連絡ください。<br />（20時以降にいただいたお申し込みにつきましては、通常、翌日の正午までに返信いたします）</li>
                <li>仮予約をお申し込みの場合は、ご利用日の7日前までにご予約確定の連絡をお願いします。<br />本予約にてお申込みの場合はその時点で確定となり、同時にキャンセル料発生の対象となります。</li>
            </ul>
          </div>

          <div className='form-container'>
            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="name">
                  名前
                  <span className="required-mark">必須</span>
                </label>
                  <input
                    type="text"
                    className='free-text'
                    {...register('name', {
                      validate: value => value.trim() !== '' || '名前は必須項目です',
                    })}
                    autoComplete='name'
                    placeholder='山田 太郎'
                    id="name"
                    onBlur={() => onBlurField('name')}
                  />
              </div>
              {nameError && <div className="error-message">{nameError}</div>}
            </div>
            
            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="companyName">
                  会社名
                  <span className="optional-mark">任意</span>
                </label>
                  <input
                    type="text"
                    className='free-text'
                    {...register('companyName')}
                    autoComplete='companyName'
                    placeholder='株式会社 FATCAT'
                    id="companyName"
                  />
              </div>
            </div>
            
            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="email">
                  メールアドレス
                  <span className="required-mark">必須</span>
                </label>
                  <input
                    type="email"
                    className='free-text'
                    {...register('email', {
                      validate: value => value.trim() !== '' || 'メールアドレスは必須項目です',
                    })}
                    autoComplete='email'
                    placeholder='example@mail.com'
                    id="email"
                    onBlur={() => onBlurField('email')}
                  />
              </div>
              {emailError && <div className="error-message">{emailError}</div>}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="phoneNumber">
                  電話番号
                  <span className="required-mark">必須</span>
                </label>
                  <input
                    type="text"
                    className='free-text'
                    {...register('phoneNumber', {
                      validate: value => value.trim() !== '' || '電話番号は必須項目です',
                    })}
                    autoComplete='phoneNumber'
                    placeholder='09012345678'
                    id="phoneNumber"
                    onBlur={() => onBlurField('phoneNumber')}
                  />
              </div>
              {phoneNumberError && <div className="error-message">{phoneNumberError}</div>}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="address">
                  住所
                  <span className="required-mark">必須</span>
                </label>
                  <input
                    type="text"
                    className='free-text'
                    {...register('address', {
                      validate: value => value.trim() !== '' || '住所は必須項目です',
                    })}
                    autoComplete='address'
                    placeholder='東京都渋谷区千駄ヶ谷5丁目'
                    id="address"
                    onBlur={() => onBlurField('address')}
                  />
              </div>
              {addressError && <div className="error-message">{addressError}</div>}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="photographerName">
                  カメラマン氏名
                  <span className="required-mark">必須</span>
                </label>
                  <input
                    type="text"
                    className='free-text'
                    {...register('photographerName', {
                      validate: value => value.trim() !== '' || 'カメラマン氏名は必須項目です',
                    })}
                    autoComplete='photographerName'
                    placeholder='鈴木 カメラ太郎'
                    id="photographerName"
                    onBlur={() => onBlurField('photographerName')}
                  />
              </div>
              {photographerNameError && <div className="error-message">{photographerNameError}</div>}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <div className='check-box-container'>
                  <div className='form-content-label' id="planLabel">
                    ご利用プラン
                    <span className="required-mark">必須</span>
                  </div>
                </div>
                <label htmlFor="plan" aria-labelledby="planLabel" className='checkbox-label'>
                  <input
                    type="checkbox"
                    {...register('plan', { required: 'ご利用プランをご確認の上、チェックを入れてください' })}
                    className='checkbox-style'
                    id="plan"
                  />
                  <span className="checkbox-text">【機材使い放題】 ¥4,500/1h（税込￥4,950/1h）</span>
                </label>
                <div className='waring-statement'>
                  ※最低利用時間は2時間です。<br />
                  ※23時～8時の深夜帯は、1時間あたりの利用料金が50％UP、最低利用時間は4時間です。
                </div>
              </div>
              {errors.plan && <div className="error-message">{errors.plan.message}</div>}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <div className='check-box-container'>
                  <div className='form-content-label' id="equipmentInsuranceLabel">
                    機材保険
                    <span className="optional-mark">任意</span>
                  </div>
                  <div className='waring-statement'>
                    お客様の不注意による機材の破損を補償します。
                  </div>
                </div>
                <label htmlFor="equipmentInsurance" aria-labelledby="equipmentInsuranceLabel" className='checkbox-label'>
                  <input
                    type="checkbox"
                    className='checkbox-style'
                    id="equipmentInsurance"
                    {...register('equipmentInsurance')}
                  />
                  <span className="checkbox-text">機材保険の付帯を希望する ¥1,000/1回（税込￥1,100）</span>
                </label>
                <div className='waring-statement'>
                  ※免責¥10,000、1機材に限ります。<br />
                  ※ホリゾントを破損・汚損した場合の修繕費用と休業補償は含みません。
                  </div>
              </div>
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <div className='check-box-container'>
                  <div className='form-content-label' id="reservationType">
                    今回のご予約の種類
                    <span className="required-mark">必須</span>
                  </div>
                </div>
                <div>
                  <label htmlFor="standardReservation" aria-labelledby="reservationType" className='checkbox-label'>
                    <input
                      type="radio"
                      {...register('reservationType', { required: true })}
                      value="本予約"
                      className='checkbox-style'
                      id="standardReservation"
                    />
                    <span className="checkbox-text">本予約</span>
                  </label>
                  <label htmlFor="temporaryReservation" aria-labelledby="reservationType" className='checkbox-label'>
                    <input
                      type="radio"
                      {...register('reservationType', { required: true })}
                      value="仮予約"
                      className='checkbox-style'
                      id="temporaryReservation"
                    />
                    <span className="checkbox-text">仮予約</span>
                  </label>
                  <div className='waring-statement'>
                    ＜本予約：何日でもご指定可能＞<br />
                    　※当スタジオからの予約確認メール受信後よりキャンセル料が発生します。<br />
                    ＜仮予約：3日迄ご指定可能＞<br />
                    　※お選びいただいた日程の1週間前からキャンセル料が発生します。
                  </div>
                </div>
              </div>
              {errors.reservationType && (
                <div className="error-message">本予約または仮予約のどちらかを選択してください</div>
              )}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="preferredDateTime">
                  ご希望の利用日時
                  <span className="required-mark">必須</span>
                </label>
                <textarea
                  {...register('preferredDateTime', {
                    validate: value => value.trim() !== '' || 'ご希望の利用日時を入力してください',
                  })}
                  className='free-textarea'
                  placeholder='2023年9月1日(金) 14時～20時'
                  id="preferredDateTime"
                  onBlur={() => onBlurField('preferredDateTime')}
                />
              </div>
              {preferredDateTimeError && <div className="error-message">{preferredDateTimeError}</div>}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <div className='check-box-container'>
                  <div className='form-content-label' id="stealContent">
                    撮影内容
                    <span className="required-mark">必須</span>
                  </div>
                </div>
                <div>
                  <label htmlFor="steal" aria-labelledby="stealContent" className='checkbox-label'>
                    <input
                      type="radio"
                      {...register('stealContent', { required: true })}
                      value="スチール撮影"
                      className='checkbox-style'
                      id="steal"
                    />
                    <span className="checkbox-text">スチール撮影</span>
                  </label>
                  <label htmlFor="movie" aria-labelledby="stealContent" className='checkbox-label'>
                    <input
                      type="radio"
                      {...register('stealContent', { required: true })}
                      value="ムービー撮影"
                      className='checkbox-style'
                      id="movie"
                    />
                    <span className="checkbox-text">ムービー撮影</span>
                  </label>
                  <label htmlFor="music" aria-labelledby="stealContent" className='checkbox-label'>
                    <input
                      type="radio"
                      {...register('stealContent', { required: true })}
                      value="楽器の演奏を伴う撮影"
                      className='checkbox-style'
                      id="music"
                    />
                    <span className="checkbox-text">楽器の演奏を伴う撮影</span>
                  </label>
                  <div className='waring-statement'>
                    ※当スタジオは吸音設備などは付帯しておりません。音の反響がございますのでご了承ください。<br />
                    ※楽器の演奏を伴う撮影につきましては制限がございます。別途ご相談ください。<br />
                    ※ダンスの撮影はできません。（2023年9月1日〜）<br />
                  </div>
                </div>
              </div>
              {errors.stealContent && (
                <div className="error-message">該当する撮影内容を選択してください</div>
              )}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="stealDetail">
                  撮影詳細
                  <span className="required-mark">必須</span>
                </label>
                <textarea
                  {...register('stealDetail', {
                    validate: value => value.trim() !== '' || '撮影内容の詳細を記入してください',
                  })}
                  className='free-textarea'
                  placeholder='俳優のポートレート撮影（全身）、ルックの撮影、ジュエリーの商品撮影、など'
                  id="stealDetail"
                  onBlur={() => onBlurField('stealDetail')}
                />
              </div>
              {stealDetailError && <div className="error-message">{stealDetailError}</div>}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="numberOfPeople">
                  ご利用人数
                  <span className="required-mark">必須</span>
                </label>
                <select
                  className='pulldown-style'
                  {...register('numberOfPeople')}
                  id="numberOfPeople"
                  onChange={onSelectNumberOfPeople}
                >
                  <option value="selectNumber">選択してください</option>
                  <option value="1">1</option>
                  <option value="2">2</option>
                  <option value="3">3</option>
                  <option value="4">4</option>
                  <option value="5">5</option>
                  <option value="6">6</option>
                  <option value="7">7</option>
                  <option value="8">8</option>
                  <option value="9">9</option>
                  <option value="10">10</option>
                  <option value="11">11</option>
                  <option value="12">12</option>
                </select>
              </div>
              {numberOfPeopleError && <div className="error-message">{numberOfPeopleError}</div>}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <div className='check-box-container'>
                  <div className='form-content-label' id="horizonProtection">
                    ホリゾントの養生
                    <span className="required-mark">必須</span>
                  </div>
                </div>
                <div className='waring-statement'>
                  足元が写らない撮影の場合は、ホリゾントの汚損を防ぐために床面の養生をおすすめします。<br />
                  （お客様の不注意で必要以上にホリゾントを汚してしまった場合には、清掃料をお支払いいただきます。）<br />
                </div>
                <div>
                  <label htmlFor="useHorizonProtection" aria-labelledby="horizonProtection" className='checkbox-label'>
                    <input
                      type="radio"
                      {...register('horizonProtection', { required: true })}
                      value="養生あり"
                      className='checkbox-style'
                      id="useHorizonProtection"
                    />
                    <span className="checkbox-text">養生あり</span>
                  </label>
                  <label htmlFor="nonHorizonProtection" aria-labelledby="horizonProtection" className='checkbox-label'>
                    <input
                      type="radio"
                      {...register('horizonProtection', { required: true })}
                      value="養生なし"
                      className='checkbox-style'
                      id="nonHorizonProtection"
                    />
                    <span className="checkbox-text">養生なし</span>
                  </label>
                </div>
                <div className='waring-statement'>
                  ※ホリゾントの床面の養生には茶色ではなく白い板を使用しています。（2023年9月1日現在）
                </div>
              </div>
              {errors.horizonProtection && (
                <div className="error-message">養生のあり/なしをご確認ください</div>
              )}
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <label className='form-content-label' htmlFor="others">
                ロケハン希望、有料消耗品の利用希望、撮影内容についてのご相談など
                  <span className="optional-mark">任意</span>
                </label>
                <textarea
                  className='free-textarea'
                  id="others"
                  {...register('others')}
                  onBlur={() => onBlurField('others')}
                />
              </div>
            </div>

            <div className='input-box'>
              <div className='flex-container'>
                <div className='check-box-container'>
                  <div className='form-content-label' id="termsAndConditionsLabel">
                    利用規約およびホリゾントルールのご確認
                    <span className="required-mark">必須</span>
                  </div>
                  <div className='waring-statement'>
                    当スタジオのホームページに掲載している「利用規約」および「ホリゾントルール」の事前確認をお願いします。
                    <a href="https://studiozebra-1st.com/policy/" target="_blank" rel="noopener noreferrer">利用規約</a>
                    <a href="https://studiozebra-1st.com/horizon/" target="_blank" rel="noopener noreferrer">ホリゾントルール</a>
                  </div>
                </div>
                <label htmlFor="termsAndConditions" aria-labelledby="termsAndConditionsLabel" className='checkbox-label'>
                  <input
                    type="checkbox"
                    {...register('termsAndConditions', { required: '利用規約・ホリゾントルールを確認しましたか？' })}
                    className='checkbox-style'
                    id="termsAndConditions"
                  />
                  <span className="checkbox-text">利用規約・ホリゾントルールを確認しました</span>
                </label>
              </div>
              {errors.termsAndConditions && <div className="error-message">{errors.termsAndConditions.message}</div>}
            </div>
          </div>

          <div className='button-container'>
            <button type="submit" className="submit-button">
              {isFormValid ? '予約フォームを送信する' : '未入力の項目があります'}
            </button>
          </div>
        </div>
      </form>
    )}
    {isSubmitted && !isError && (
      <div>
        {/* 送信完了ページの内容 */}
        <div className='background-container'>
          <div className='title'>
            <p className='uper-title'>スタジオゼブラ ご予約フォーム</p>
            <p className='complete-title'>
              ご予約内容の送信が完了しました。<br />
              担当者からのご連絡をお待ちください。
            </p>
          </div>
        </div>
      </div>
    )}
    {isError && (
      <div>
        {/* エラーページの内容 */}
        <div className='background-container'>
          <div className='title'>
            <p className='uper-title'>スタジオゼブラ ご予約フォーム</p>
            <p className='complete-title'>
              送信中にエラーが発生しました。<br />
              大変恐れ入りますが、以下の電話番号までご予約内容のご連絡をお願いいたします。<br />
              090-6707-0936
            </p>
          </div>
        </div>
      </div>
    )}    
    </div>
  );
};

export default ReservationForm;