import React, { useState } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { motion } from 'framer-motion';
import { ChevronDownIcon,ExternalLink } from 'lucide-react';
import DatePicker from 'react-datepicker';
import "react-datepicker/dist/react-datepicker.css";

const InputField = ({ label, name, register, required, error, type = 'text', placeholder }) => (
  <div className="mb-4">
    <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor={name}>
      {label}
      {required && <span className="text-red-500 ml-1">*</span>}
    </label>
    <input
      type={type}
      id={name}
      {...register(name, { required: required && `${label}は必須項目です` })}
      className={`w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500 ${
        error ? 'border-red-500' : 'border-gray-300'
      }`}
      placeholder={placeholder}
    />
    {error && <p className="mt-1 text-sm text-red-500">{error.message}</p>}
  </div>
);

const CheckboxField = ({ label, name, register, required, error }) => (
  <div className="mb-4">
    <label className="flex items-center space-x-2">
      <input
        type="checkbox"
        {...register(name, { required: required && `${label}は必須項目です` })}
        className="form-checkbox h-5 w-5 text-blue-600"
      />
      <span className="text-sm text-gray-700">{label}</span>
      {required && <span className="text-red-500 ml-1">*</span>}
    </label>
    {error && <p className="mt-1 text-sm text-red-500">{error.message}</p>}
  </div>
);

const RadioField = ({ label, name, options, register, required, error }) => (
  <div className="mb-4">
    <p className="block text-sm font-medium text-gray-700 mb-1">
      {label}
      {required && <span className="text-red-500 ml-1">*</span>}
    </p>
    <div className="space-y-2">
      {options.map((option) => (
        <label key={option.value} className="flex items-center space-x-2">
          <input
            type="radio"
            value={option.value}
            {...register(name, { required: required && `${label}は必須項目です` })}
            className="form-radio h-5 w-5 text-blue-600"
          />
          <span className="text-sm text-gray-700">{option.label}</span>
        </label>
      ))}
    </div>
    {error && <p className="mt-1 text-sm text-red-500">{error.message}</p>}
  </div>
);

const SelectField = ({ label, name, options, register, required, error }) => (
  <div className="mb-4">
    <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor={name}>
      {label}
      {required && <span className="text-red-500 ml-1">*</span>}
    </label>
    <div className="relative">
      <select
        id={name}
        {...register(name, { required: required && `${label}は必須項目です` })}
        className={`w-full p-2 border rounded-md appearance-none focus:ring-2 focus:ring-blue-500 ${
          error ? 'border-red-500' : 'border-gray-300'
        }`}
      >
        <option value="">選択してください</option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
      <ChevronDownIcon className="absolute right-2 top-2.5 h-5 w-5 text-gray-400" />
    </div>
    {error && <p className="mt-1 text-sm text-red-500">{error.message}</p>}
  </div>
);

const TextareaField = ({ label, name, register, required, error, placeholder }) => (
  <div className="mb-4">
    <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor={name}>
      {label}
      {required && <span className="text-red-500 ml-1">*</span>}
    </label>
    <textarea
      id={name}
      {...register(name, { required: required && `${label}は必須項目です` })}
      className={`w-full p-2 border rounded-md focus:ring-2 focus:ring-blue-500 ${
        error ? 'border-red-500' : 'border-gray-300'
      }`}
      rows="4"
      placeholder={placeholder}
    ></textarea>
    {error && <p className="mt-1 text-sm text-red-500">{error.message}</p>}
  </div>
);

const ModernReservationForm = () => {
  const {
    register,
    handleSubmit,
    control,
    formState: { errors },
    watch
  } = useForm();
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [isError, setIsError] = useState(false);

  const apiGatewayUrl = 'https://tj3alvdeza.execute-api.ap-northeast-1.amazonaws.com/development/send';

  const selectedDate = watch('preferredDateTime');
  const startTime = watch('startTime');
  const endTime = watch('endTime');

  const generateTimeOptions = () => {
    const options = [];
    for (let i = 0; i < 24; i++) {
      for (let j = 0; j < 60; j += 30) {
        const hour = i.toString().padStart(2, '0');
        const minute = j.toString().padStart(2, '0');
        options.push(`${hour}:${minute}`);
      }
    }
    return options;
  };

  const timeOptions = generateTimeOptions();

  const formatPreferredDateTime = (date, start, end) => {
    if (!date || !start || !end) return '';
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${year}-${month}-${day} ${start}-${end}`;
  };
 
  const onSubmit = async(data) => {
    const formattedDateTime = formatPreferredDateTime(data.preferredDateTime, data.startTime, data.endTime);
    const submissionData = {
      ...data,
      preferredDateTime: formattedDateTime
    };

    // リクエストデータを準備
    const requestData = {
      body: JSON.stringify(submissionData),
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

  if (isSubmitted) {
    return (
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="max-w-2xl mx-auto mt-10 p-6 bg-white rounded-lg shadow-lg"
      >
        <h2 className="text-2xl font-bold text-center text-green-600 mb-4">予約完了</h2>
        <p className="text-center text-gray-700">
          ご予約内容の送信が完了しました。担当者からのご連絡をお待ちください。
        </p>
      </motion.div>
    );
  }

  if (isError) {
    return (
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="max-w-2xl mx-auto mt-10 p-6 bg-white rounded-lg shadow-lg"
      >
        <h2 className="text-2xl font-bold text-center text-red-600 mb-4">エラー</h2>
        <p className="text-center text-gray-700">
          送信中にエラーが発生しました。大変恐れ入りますが、以下の電話番号までご予約内容のご連絡をお願いいたします。
        </p>
        <p className="text-center text-xl font-bold mt-4">090-6707-0936</p>
      </motion.div>
    );
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      className="max-w-2xl mx-auto mt-10 p-6 bg-white rounded-lg shadow-lg"
    >
      <h1 className="text-3xl font-bold text-center text-gray-800 mb-6">スタジオゼブラ ご予約フォーム</h1>
      <p className="text-center text-gray-600 mb-8">本予約および仮予約のお申し込みを承ります。</p>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        <InputField
          label="名前"
          name="name"
          register={register}
          required={true}
          error={errors.name}
          placeholder="山田 太郎"
        />
        <InputField
          label="会社名"
          name="companyName"
          register={register}
          required={false}
          error={errors.companyName}
          placeholder="株式会社 FATCAT"
        />
        <InputField
          label="メールアドレス"
          name="email"
          register={register}
          required={true}
          error={errors.email}
          type="email"
          placeholder="example@mail.com"
        />
        <InputField
          label="電話番号"
          name="phoneNumber"
          register={register}
          required={true}
          error={errors.phoneNumber}
          placeholder="09012345678"
        />
        <InputField
          label="住所"
          name="address"
          register={register}
          required={true}
          error={errors.address}
          placeholder="東京都渋谷区千駄ヶ谷5丁目"
        />
        <InputField
          label="カメラマン氏名"
          name="photographerName"
          register={register}
          required={true}
          error={errors.photographerName}
          placeholder="鈴木 カメラ太郎"
        />

        {/*
          <CheckboxField
            label="【機材使い放題】 ¥4,500/1h（税込￥4,950/1h）"
            name="plan"
            register={register}
            required={true}
            error={errors.plan}
          />
        */}

        <RadioField
          label="予約の種類"
          name="reservationType"
          options={[
            { value: "本予約", label: "本予約" },
            { value: "仮予約", label: "仮予約" },
          ]}
          register={register}
          required={true}
          error={errors.reservationType}
        />
        
        {/*
          <TextareaField
            label="ご希望の利用日時"
            name="preferredDateTime"
            register={register}
            required={true}
            error={errors.preferredDateTime}
            placeholder="2023年9月1日(金) 14時～20時"
          />
        */}
        <div className="space-y-2">
          <label className="block text-sm font-medium text-gray-700">
            ご希望の利用日時<span className="text-red-500 ml-1">*</span>
          </label>
          <div className="flex flex-col sm:flex-row space-y-2 sm:space-y-0 sm:space-x-4">
            <div className="flex-1">
              <Controller
                control={control}
                name="preferredDateTime"
                rules={{ required: "予約日を選択してください" }}
                render={({ field }) => (
                  <DatePicker
                    selected={field.value}
                    onChange={(date) => field.onChange(date)}
                    dateFormat="yyyy/MM/dd"
                    className="w-full p-2 border border-gray-300 rounded-md"
                    placeholderText="日付を選択"
                  />
                )}
              />
            </div>
            <div className="flex-1">
              <select
                {...register("startTime", { required: "開始時間を選択してください" })}
                className="w-full p-2 border border-gray-300 rounded-md"
              >
                <option value="">開始時間</option>
                {timeOptions.map((time) => (
                  <option key={`start-${time}`} value={time}>{time}</option>
                ))}
              </select>
            </div>
            <div className="flex-1">
              <select
                {...register("endTime", { required: "終了時間を選択してください" })}
                className="w-full p-2 border border-gray-300 rounded-md"
              >
                <option value="">終了時間</option>
                {timeOptions.map((time) => (
                  <option key={`end-${time}`} value={time}>{time}</option>
                ))}
              </select>
            </div>
          </div>
          {(errors.preferredDateTime || errors.startTime || errors.endTime) && (
            <p className="mt-1 text-sm text-red-600">
              {errors.preferredDateTime?.message || errors.startTime?.message || errors.endTime?.message}
            </p>
          )}
        </div>

        {selectedDate && startTime && endTime && (
          <p className="text-sm text-gray-600">
            選択された日時: {formatPreferredDateTime(selectedDate, startTime, endTime)}
          </p>
        )}

        <RadioField
          label="撮影内容"
          name="stealContent"
          options={[
            { value: "スチール撮影", label: "スチール撮影" },
            { value: "ムービー撮影", label: "ムービー撮影" },
            { value: "楽器の演奏を伴う撮影", label: "楽器の演奏を伴う撮影" },
          ]}
          register={register}
          required={true}
          error={errors.stealContent}
        />

        <TextareaField
          label="撮影詳細"
          name="stealDetail"
          register={register}
          required={true}
          error={errors.stealDetail}
          placeholder="俳優のポートレート撮影（全身）、ルックの撮影、ジュエリーの商品撮影、など"
        />

        <SelectField
          label="ご利用人数"
          name="numberOfPeople"
          options={[
            { value: "1", label: "1人" },
            { value: "2", label: "2人" },
            { value: "3", label: "3人" },
            { value: "4", label: "4人" },
            { value: "5", label: "5人" },
            { value: "6", label: "6人" },
            { value: "7", label: "7人" },
            { value: "8", label: "8人" },
            { value: "9", label: "9人" },
            { value: "10", label: "10人" },
            { value: "11", label: "11人" },
            { value: "12", label: "12人" },
          ]}
          register={register}
          required={true}
          error={errors.numberOfPeople}
        />

        <RadioField
          label="ホリゾントの養生"
          name="horizonProtection"
          options={[
            { value: "養生あり", label: "養生あり" },
            { value: "養生なし", label: "養生なし" },
          ]}
          register={register}
          required={true}
          error={errors.horizonProtection}
        />

        <TextareaField
          label="その他のご要望"
          name="others"
          register={register}
          required={false}
          error={errors.others}
          placeholder="ロケハン希望、有料消耗品の利用希望、撮影内容についてのご相談など"
        />
        
        <div className="space-y-2">
          <p className="text-sm text-gray-700 font-medium">以下の規約をご確認ください：</p>
          <div className="flex flex-col space-y-1">
            <a 
              href="https://studiozebra-1st.com/policy/" 
              target="_blank" 
              rel="noopener noreferrer"
              className="flex items-center text-blue-600 hover:text-blue-800 transition-colors duration-200"
            >
              <ExternalLink size={16} className="mr-1 flex-shrink-0" />
              <span className="underline">利用規約</span>
            </a>
            <a 
              href="https://studiozebra-1st.com/horizon/" 
              target="_blank" 
              rel="noopener noreferrer"
              className="flex items-center text-blue-600 hover:text-blue-800 transition-colors duration-200"
            >
              <ExternalLink size={16} className="mr-1 flex-shrink-0" />
              <span className="underline">ホリゾントルール</span>
            </a>
          </div>
        </div>

        <div className="flex items-start space-x-2 mt-2">
          <input
            type="checkbox"
            id="termsAndConditions"
            {...register('termsAndConditions', { required: '利用規約とホリゾントルールを確認して同意してください。' })}
            className="form-checkbox h-5 w-5 text-blue-600 transition duration-150 ease-in-out"
          />
          <label htmlFor="termsAndConditions" className="text-sm text-gray-700">
            利用規約・ホリゾントルールを確認しました
            <span className="text-red-500 ml-1">*</span>
          </label>
        </div>
        {errors.termsAndConditions && (
          <p className="mt-1 text-sm text-red-600">{errors.termsAndConditions.message}</p>
        )}

        <div className="text-center">
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            type="submit"
            className="bg-[#82C2A9] text-black px-6 py-3 rounded-md font-medium hover:bg-[#6eab94] transition duration-300"
          >
            予約フォームを送信する
          </motion.button>
        </div>
      </form>
    </motion.div>
  );
};

export default ModernReservationForm;